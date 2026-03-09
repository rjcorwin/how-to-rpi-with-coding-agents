# RPI Guide: Intermediate

Builds on the [beginner track](1-beginner.md) by adding: structured plan folders, a CONTRIBUTING.md with templates, and AI self-review loops that catch gaps before you spend time reviewing.

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

## Research

### AI:Work — Write research.md

**Prompt:**
```
Read CONTRIBUTING.md for context. You are starting research for adding a dark mode / light mode toggle to our todo app.

Requirements:
- User can switch between dark and light themes
- The toggle should be visible and accessible
- Theme preference should persist across page reloads

Read the existing codebase first, then write plans/x7k-dark-mode/research.md covering requirements, system architecture, constraints, prior art, and open questions.
```

Same output expectations as the beginner track, but now following the structured template from CONTRIBUTING.md.

### AI:Review — Write research-review-001.md

Now we have the AI review its own work. This is a quality gate — a second pass to catch gaps before you spend your time reviewing.

**Prompt:**
```
Read CONTRIBUTING.md for context. Review plans/x7k-dark-mode/research.md and write plans/x7k-dark-mode/research-review-001.md following the template.
```

The review should flag:
- Any **High** gaps (critical missing info that blocks planning)
- **Medium** gaps (important but not blocking)
- **Low** gaps (nice-to-have)

### AI:Gate — Should we revise?

**Prompt:**
```
Read CONTRIBUTING.md for context. Read plans/x7k-dark-mode/research.md and plans/x7k-dark-mode/research-review-001.md. Are there any High gaps or unresolved questions? If yes, summarize what needs revision. If no, confirm ready for human review.
```

If the gate says revision is needed, go back to AI:Work and have the AI address the gaps. If it passes, move on.

### Human:Review — Your turn

Read the research document and make the actual decisions. For each open question, ask the AI to present options with pros and cons:

**Prompt:**
```
In plans/x7k-dark-mode/research.md, you raised the question of where to store the theme preference. Give me the options with pros and cons for each.
```

Review the options, pick one, and have the agent record it:

**Prompt:**
```
Go with localStorage. Update plans/x7k-dark-mode/research.md to record this decision under the open questions section.
```

Repeat for each open question until every decision is recorded in the research doc.

## Plan

### AI:Work — Write plan.md

**Prompt:**
```
Read CONTRIBUTING.md for context. Read plans/x7k-dark-mode/research.md for decisions and context.

Write plans/x7k-dark-mode/plan.md detailing the implementation approach.
```

### AI:Review — Write plan-review-001.md

**Prompt:**
```
Read CONTRIBUTING.md for context. Review plans/x7k-dark-mode/plan.md against plans/x7k-dark-mode/research.md and write plans/x7k-dark-mode/plan-review-001.md following the template.
```

### AI:Gate — Should we revise?

**Prompt:**
```
Read CONTRIBUTING.md for context. Read plans/x7k-dark-mode/plan.md and plans/x7k-dark-mode/plan-review-001.md. Are there any High concerns? If yes, summarize what needs revision. If no, confirm ready for human review.
```

### Human:Review — Approve the plan

Read the plan. Does it match your research decisions? Is anything overcomplicated or missing? Edit and approve before moving on.

## Implement

### AI:Work — Implement and write devlog

**Prompt:**
```
Read CONTRIBUTING.md for context. Read plans/x7k-dark-mode/plan.md.

Implement the plan. When done, write plans/x7k-dark-mode/devlog-001.md covering what was done, tricky parts, and any decisions made.
```

### AI:Review — Write code-review-001.md

**Prompt:**
```
Read CONTRIBUTING.md for context. Review the implementation against plans/x7k-dark-mode/plan.md and write plans/x7k-dark-mode/code-review-001.md following the template.
```

### AI:Gate — Ship it?

**Prompt:**
```
Read CONTRIBUTING.md for context. Read plans/x7k-dark-mode/devlog-001.md and plans/x7k-dark-mode/code-review-001.md. Are there any High issues? If yes, write plans/x7k-dark-mode/plan-001.md with fixes needed. If no, write plans/x7k-dark-mode/pr.md and confirm ready for human review.
```

### Human:Review — Final approval

Test the implementation. Review the PR description. Merge when satisfied.

Ready to automate the loops? Move on to the [Advanced Guide](3-advanced.md).
