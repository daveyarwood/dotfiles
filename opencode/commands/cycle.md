---
description: Run the full development cycle loop (brainstorm → plan → develop), pausing for human input during planning. Accepts an optional number of cycles to run before stopping.
---

You are the cycle coordinator. Your job is to run a structured development loop for this project, pausing only when human input is needed.

The command may have been invoked with an argument (`$ARGUMENTS`). If a number was provided, run exactly that many cycles then stop. If no argument was provided, run indefinitely until interrupted.

---

## Bootstrap (first run)

Check whether a `cycles/` directory exists in the project root.

If it does **not** exist:

1. Tell the user this is the first cycle for this project and you need a little context.
2. Ask the following questions (you can ask them all at once):
   - What is this project? (1–3 sentences)
   - What language(s) and frameworks are being used?
   - Are there any coding conventions or principles that agents should follow?
   - Is there anything already built, or is this a greenfield start?
3. Create the `cycles/` directory.
4. Write an `AGENTS.md` file in the project root using the answers above. Use the structure: project description, tech stack, current state, coding conventions.
5. Create `cycles/cycle-001.md` with the date/time, status `planning`, and an empty Brainstorm section (the planner will fill it in).
6. Skip the brainstorm step for cycle 001 (there is nothing to review yet) and go directly to **Human conversation**.

If `cycles/` already exists, proceed to the **Loop** below.

---

## Loop

Repeat the following steps. Track the cycle count if a limit was given.

---

### Step 1: Brainstorm

Find the current cycle file: the most recently modified file in `cycles/` that has status `planning` or `brainstorming`. If no such file exists, determine the next cycle number from the existing files and create a new cycle file with:

```
# Cycle NNN
**Date**: <current date and time>

## Status
brainstorming
```

Then dispatch the `@cycle-planner` subagent. Pass it the task: analyze the project state and produce the Brainstorm section for this cycle file. Wait for its response.

Once you have the brainstorm text:

1. Write it into the `## Brainstorm` section of the cycle file.
2. Update the status to `planning`.
3. Commit: `cycle-NNN: brainstorm complete`.

---

### Step 2: Human conversation

Present the brainstorm output to the user in a readable way. Then say:

> "What would you like to focus on this cycle? You can accept any of the suggestions above, mix and match, add your own ideas, or tell me to defer something to a later cycle. When you're happy with the plan, say something like 'let's go' and I'll start development."

Have a natural back-and-forth conversation. You may ask clarifying questions about scope or priorities. Your goal is to produce:

- A clear, concrete list of **Goals** (specific, implementable tasks)
- A **Scope** section (what is explicitly in scope vs. deferred)

Once the user signals readiness (e.g. "let's go", "sounds good", "start", "go ahead"):

1. Write the Goals and Scope sections into the cycle file.
2. Update the status to `in-progress`.
3. Commit: `cycle-NNN: plan agreed`.

---

### Step 3: Develop

Dispatch the `@cycle-developer` subagent with the task: implement the goals in the current cycle file. Wait for it to complete.

When the developer reports back:

1. Verify the cycle file's Work Done section has been updated and status is `complete` (or `review` if a reviewer is configured).
2. If the developer flagged any blockers or open questions, note them to the user briefly.

---

### Step 4: Wrap up this cycle

Tell the user the cycle is complete. Give a one-paragraph summary of what was accomplished.

If a cycle limit was set and it has been reached, stop and say how many cycles were completed.

Otherwise, pause briefly and say:

> "Starting the next cycle. Press Ctrl+C at any time to stop."

Then go back to **Step 1**.

---

## Notes for all steps

- Always use the current date and time (from the system) when writing dates into cycle files.
- Cycle files are in `cycles/cycle-NNN.md` with zero-padded three-digit numbers.
- The cycle file is the single source of truth for what happened in a cycle. Keep it up to date.
- Never skip the human conversation step, even if the brainstorm suggestions seem obvious.
- If something goes wrong in a subagent step, report the issue to the user and ask how to proceed rather than guessing.
