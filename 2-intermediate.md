# RPI Guide: Intermediate

The [beginner track](1-beginner.md) gave you the shape of RPI — research, plan, implement — with you reviewing the output at each phase. That works, but it has a problem: the first pass from a coding agent often has gaps — missing context, shallow analysis, overlooked edge cases. You might catch them in review. You might not. Either way, it's your time spent on something the AI could have caught itself.

The intermediate track fixes this by wrapping each phase in a work-review-gate loop (that we'll refer to as a cook loop). Before you ever look at the output, the AI reviews its own work and decides if it's ready. You only step in once the loop says it's done. Alongside this, we introduce structured plan folders and a [CONTRIBUTING.md](https://gist.github.com/rjcorwin/296885590dc8a4ebc64e70879dc04a0f) with templates — so every feature has a consistent home for its research, decisions, and implementation history.

Running the loop manually means a fair amount of prompting. That's intentional here — understanding each step makes the process legible before you automate it. The [advanced track](3-advanced.md) handles the loops for you.

## Prerequisites

- Complete the [beginner track](1-beginner.md) or understand the basics of Research, Plan, Implement
- Read [CONTRIBUTING.md](https://gist.github.com/rjcorwin/296885590dc8a4ebc64e70879dc04a0f) — it defines the full file structure, workflow steps, and templates used in this track

## Step 0: Generate the todo app

If you haven't already, generate the todo app:

**Prompt:**
```
Create a simple todo app using HTML, CSS, and vanilla JavaScript in a single index.html file. It should support adding, completing, and deleting todos. Keep it simple — no frameworks, no build tools.
```

## Step 1: Set up the plan folder

Every feature gets its own plan folder and git branch. This keeps research, planning, and implementation artifacts organized and tied to a PR.

```bash
curl https://gist.githubusercontent.com/rjcorwin/296885590dc8a4ebc64e70879dc04a0f/raw/46035954b5a0423c0c62b96c3ff8e9295169bf4f/CONTRIBUTING.md > CONTRIBUTING.md
mkdir -p plans/x7k-dark-mode
git checkout -b x7k-dark-mode
```

> **Don't want CONTRIBUTING.md in your repo?** You can add these workflow instructions as a Claude skill instead — just ask Claude to do it for you.

## Research

Each step runs in a fresh context. Run `/clear` between them.

### AI:Work — Write research.md

**Prompt:**
```
We're going to add a dark mode / light mode toggle to our todo app.

Requirements:
- User can switch between dark and light themes
- The toggle should be visible and accessible
- Theme preference should persist across page reloads

Read the existing codebase first, create a new plan folder and research.md per CONTRIBUTING.md.
```

Same output expectations as the beginner track, but now following the structured template from CONTRIBUTING.md.

**Run `/clear`.**

### AI:Review — Write research review

**Prompt:**
```
Review plans/x7k-dark-mode/research.md and write a research review in the plan folder per CONTRIBUTING.md.
```

The review should flag:
- Any **High** gaps (critical missing info that blocks planning)
- **Medium** gaps (important but not blocking)
- **Low** gaps (nice-to-have)

**Run `/clear`.**

### AI:Gate — Should we revise?

**Prompt:**
```
Read plans/x7k-dark-mode/research.md and the latest research review in plans/x7k-dark-mode/. Are there any High gaps or unresolved questions? If yes, summarize what needs revision. If no, confirm ready for human review.
```

If the gate says revision is needed, run `/clear`, go back to AI:Work, and have the AI address the gaps. If it passes, move on.

### Human:Review — Your turn

Read the research document and any decision files in the plan folder. For each open question, pick an option and have the agent record it:

**Prompt:**
```
Go with localStorage. Update plans/x7k-dark-mode/research.md to record this decision under the open questions section.
```

Repeat for each open question until every decision is recorded in the research doc.

## Plan

### AI:Work — Write plan.md

**Prompt:**
```
Read the research.md and then write the plan.md for plans/x7k-dark-mode per CONTRIBUTING.md
```

**Run `/clear`.**

### AI:Review — Write plan review

**Prompt:**
```
Review the latest plan in plans/x7k-dark-mode/ against plans/x7k-dark-mode/research.md and write a plan review in the plan folder per CONTRIBUTING.md.
```

**Run `/clear`.**

### AI:Gate — Should we revise?

**Prompt:**
```
Read the latest plan and latest plan review in plans/x7k-dark-mode/. Are there any High concerns? If yes, summarize what needs revision. If no, confirm ready for human review.
```

If the gate says revision is needed, run `/clear`, go back to AI:Work, and address the gaps. If it passes, move on.

### Human:Review — Approve the plan

Read the plan. Does it match your research decisions? Is anything overcomplicated or missing? Edit and approve before moving on.

**Run `/clear`.**

## Implement

### AI:Work — Implement and write devlog

**Prompt:**
```
Go forth and implement the plan in plan/x7k-dark-mode/plan.md. When done, write a new devlog in the plan folder per CONTRIBUTING.md covering what was done, tricky parts, and any decisions made.
```

The devlog replaces the manual debrief from the beginner track — instead of asking "what was tricky?" after the fact, the agent documents it as a persistent artifact of the process.

**Run `/clear`.**

### AI:Review — Write code review

**Prompt:**
```
Review the implementation against plans/x7k-dark-mode/plan.md, read the latest devlog in the plan for context on how implementation went, read through the implementation's code changes, and then write a code review file in the plan folder per CONTRIBUTING.md
```

**Run `/clear`.**

### AI:Gate — Ship it?

**Prompt:**
```
Read the latest devlog and latest code review in plans/x7k-dark-mode/. Are there any High issues? If yes, write a new plan in the plan folder with fixes needed per CONTRIBUTING.md. If no, write plans/x7k-dark-mode/pr.md and confirm ready for human review.
```

### Human:Review — Final approval

Test the implementation. Review the PR description. Merge when satisfied.

Ready to automate the loops? Move on to the [Advanced Guide](3-advanced.md).
