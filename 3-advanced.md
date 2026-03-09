# RPI Guide: Advanced

Builds on the [intermediate track](2-intermediate.md) by automating the AI work-review-gate cycles using the [cook](https://github.com/rjcorwin/cook) CLI. Instead of manually running three prompts per phase, you run one command and cook loops the agent through work, review, and gate until it's satisfied.

## Prerequisites

- Complete the [intermediate track](2-intermediate.md) (or at least read it — you need to understand the loop you're automating)
- Read [CONTRIBUTING.md](https://gist.github.com/rjcorwin/296885590dc8a4ebc64e70879dc04a0f)
- Install [cook](https://github.com/rjcorwin/cook): `npm install -g @anthropic/cook`
- Run `cook doctor` to verify your setup

## Step 0: Generate the todo app

If you haven't already, generate the todo app:

**Prompt:**
```
Create a simple todo app using HTML, CSS, and vanilla JavaScript in a single index.html file. It should support adding, completing, and deleting todos. Keep it simple — no frameworks, no build tools.
```

## Step 1: Set up the plan folder

```bash
mkdir -p plans/x7k-dark-mode
git checkout -b x7k-dark-mode
```

## Research — One cook command

In the intermediate track, the research phase was three manual prompts (work, review, gate) with potential loops back. Cook automates this entire cycle:

```bash
cook "Read CONTRIBUTING.md for context. You are starting research for adding a dark mode / light mode toggle to our todo app.

Requirements:
- User can switch between dark and light themes
- The toggle should be visible and accessible
- Theme preference should persist across page reloads

Read the existing codebase first, then write plans/x7k-dark-mode/research.md covering requirements, system architecture, constraints, prior art, and open questions."
```

Cook will:
1. **Work** — The agent writes `research.md`
2. **Review** — A second pass reviews the output and flags issues
3. **Gate** — A third pass decides if the review passes or if the agent needs to iterate

If the gate says "ITERATE", cook loops back automatically. When it says "DONE", you get the result.

**Human:Review** — You still make the decisions. For each open question, ask the AI to present options with pros and cons, pick one, and have the agent update `research.md` with your decision. (Same process as the [beginner](1-beginner.md#making-decisions) and [intermediate](2-intermediate.md#humanreview--your-turn) tracks.)

## Plan — One cook command

```bash
cook "Read CONTRIBUTING.md for context. Read plans/x7k-dark-mode/research.md for decisions and context. Write plans/x7k-dark-mode/plan.md detailing the implementation approach."
```

**Human:Review** — Read the plan, approve or edit.

## Implement — Cook loop over plan phases

Here's where it gets powerful. If your plan has multiple phases or steps, you can run cook once per phase, letting it handle the iteration within each:

```bash
cook "Read CONTRIBUTING.md for context. Read plans/x7k-dark-mode/plan.md. Implement step 1: [description]. When done, write plans/x7k-dark-mode/devlog-001.md."
```

```bash
cook "Read CONTRIBUTING.md for context. Read plans/x7k-dark-mode/plan.md and plans/x7k-dark-mode/devlog-001.md. Implement step 2: [description]. When done, update devlog-001.md."
```

Each cook command handles the work-review-gate cycle for that step. You review between steps — checking the devlog and the code — and move on when satisfied.

For a plan with N steps, this becomes a simple loop:

```bash
for step in 1 2 3; do
  cook "Read CONTRIBUTING.md for context. Read plans/x7k-dark-mode/plan.md. Implement step $step. Update plans/x7k-dark-mode/devlog-001.md."
  echo "Review step $step, then press enter to continue"
  read
done
```

## What changed from intermediate?

| | Intermediate | Advanced |
|---|---|---|
| Work-review-gate | 3 manual prompts per phase | 1 cook command per phase |
| Iteration on failures | You re-run prompts manually | Cook loops automatically |
| Human checkpoints | Same | Same — you still review between phases |
| Plan execution | One big implement prompt | One cook command per plan step |

The human checkpoints don't change. You still make the decisions, review the research, approve the plan, and test the implementation. Cook just removes the mechanical overhead of running the agent loop yourself.

## Iterating back to Research

Sometimes implementation reveals decisions that were never made explicitly — they got made on the fly, buried in code. When the debrief surfaces judgment calls you didn't anticipate, don't patch over it. Reset and run the loop with what you learned.

### Step 1: Extract the implicit decisions

Read the debrief. For each judgment call the agent made, add it to `research.md` as a resolved open question.

```bash
cook "Based on the devlog, add any decisions you made during implementation to plans/x7k-dark-mode/research.md as resolved open questions."
```

Review what it added. Correct any decisions you'd make differently.

### Step 2: Revert the implementation and delete the plan

```bash
git checkout .
rm plans/x7k-dark-mode/plan.md
```

`research.md` is untracked or committed separately — only the code changes get discarded.

### Step 3: Re-run the loop

Run `/clear`, then go straight to the Plan phase. Research is already done — `research.md` now has the full picture including decisions from the first pass. The second implementation starts with a complete picture, so the agent isn't guessing and neither are you.
