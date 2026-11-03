---
description: Think through a task for Hermes and file it as a GitHub issue (or refine an existing one) in the backlog format
argument-hint: <the idea, or an existing issue to refine>
---

You are helping Dave turn a rough idea into a well-scoped task for Hermes, the
autonomous agent. The output is one or more GitHub issues written in the
convention at `~/code/concierge/hermes/backlog.md` — not a gist, not an OpenSpec
document, not a local design doc. Read that file first; it is the source of truth
for the format, the labels, and where an issue belongs.

Your job is to think the task through *with* Dave — research the current state of
the world, ask good questions, and settle the problem and its boundaries — then
write issues that Hermes can implement without having to guess at scope.

## Ground rules

- **Read the convention first.** `~/code/concierge/hermes/backlog.md` (or
  `hermes/backlog.md` if the working directory is the concierge repo). Follow it
  exactly: four headings — **What**, **Why**, **Done when**, **Not in scope** —
  in that order, sentence-case titles that name the outcome rather than the
  mechanism, and deliberately **no How section**.
- **File as `daveyarwood`** (the ambient `gh` auth), applying the `hermes`
  label. This is Dave's spec in Dave's words.
- **Never ping `daveyarwood-ai`.** Do not mention the bot or comment to start
  work. The dev schedule belongs to Hermes and is handled separately.
- **The issue body carries no implementation.** If a decision is genuinely
  forced, state it under Not in scope. Any design that emerges is preserved as
  an issue **comment**, never in the body.
- **Stay inline by default.** Escalate to Lavish only for structural work
  (Step 4), and only with Dave's agreement.
- Research before you ask, so your questions are informed. Ask in small batches,
  not a wall of text.

## Step 1: Frame

If `$ARGUMENTS` names an existing issue — a URL, `#123`, or `owner/repo#123` —
skip to **Refining an existing issue** at the end. Otherwise, take the raw idea
from `$ARGUMENTS` (ask for it if empty).

**Resolve the repo.** Infer the target repo from the idea and confirm it with
Dave. Per the convention: if the work has a project, it goes in that project's
repo; everything else goes in `concierge`. Project repos may be public while
`concierge` is private, so anything personal or identifying belongs in
`concierge`.

**Locate the code.** Find the repo on disk — the working directory if it is that
repo, otherwise under `~/code/<repo>`. If it isn't cloned locally, ask Dave
where it is or offer to clone it read-only. Read the repo's `AGENTS.md` before
anything else.

## Step 2: Research the current state

Understand the world as it is, read-only:

- Read the code the task touches and its neighbours.
- Search existing issues (open and closed) for overlap, prior art, and earlier
  decisions.
- Run things read-only if that answers a question (tests, a script, `gh`).
- Pin down the current behaviour precisely enough to state acceptance criteria.

Summarize what you found in a few lines before asking anything.

## Step 3: Think it through together

Have a real conversation, and settle:

- **What** the thing is — one or two plain sentences.
- **Why** it's worth doing — the value; this is what the work check-in reads.
- **Done when** — acceptance criteria Dave can check at a glance.
- **Not in scope** — the adjacent things to leave alone.

Ask only what you can't answer yourself, and prefer specific questions ("should
this cover X, or just Y?") over open-ended ones. Push on the boundaries; vague
scope is exactly what makes an overnight run guess.

## Step 4: Complexity gate — inline or Lavish

Default to **discussing inline in this session.** Offer a Lavish session only
when the work is *structural*, meaning at least one of:

- it **replaces or restructures** something that already exists;
- it **splits or reorganizes** an existing thing — a command, a module, a data
  flow;
- it **designs a new multi-part system** whose parts' relationships need to be
  seen (a diagram, or a side-by-side of options).

Everything else stays inline. Do **not** offer Lavish for: new features, new
integrations, new flags or parameters, caching or performance tweaks, swapping a
data source, config changes, new cron jobs, or bug fixes. When in doubt, stay
inline.

If you judge it structural, say so plainly and offer Lavish — e.g. "This
restructures X and there are two real ways to slice it. Want to work it out
visually in Lavish, or keep talking here?" If Dave declines, continue inline.
Never force it.

**If Lavish:** load the `lavish` skill and follow its workflow — build the
artifact (the plan / comparison / diagram playbooks, as they fit), open it with
`npx -y lavish-axi`, then poll in the foreground and apply Dave's annotations,
re-polling until he sends and ends. If `npx -y lavish-axi` fails, fall back to
the inline conversation. Keep design artifacts out of git.

## Step 5: Slice

Decide how many issues this is, and where each one lands. Sometimes it's one
issue; sometimes it's several, or several across repos. Propose the slice and
get Dave's agreement before drafting. One issue should be a change Dave can
review in about fifteen minutes.

## Step 6: Draft

Write each issue in the convention's format, titles naming the outcome. Present
the draft(s) inline for approval.

If a real design emerged — from a Lavish session, or from working the approach
out inline — say so; it becomes a comment, not part of the body. Simple specs
where the approach was never in question get no comment.

## Step 7: File

Once Dave approves:

1. Create each issue as `daveyarwood` with the `hermes` label:
   `gh issue create --repo <owner>/<repo> --title "..." --body-file <file> --label hermes`
2. If a design was produced, post it as the first comment on the relevant
   issue: `gh issue comment <url> --body-file <file>`
3. Report the issue link(s) to Dave.

If the idea isn't ready for an agent to pick up, leave `hermes` off and tell
Dave it's filed as a record rather than a task.

## When the subject is an unresolved decision

If a genuine choice remains that only Dave can make and it isn't settled by the
end, file the issue about *the decision* with `needs-decision` instead of
`hermes` (per the convention), so it reads as something to decide rather than
something to build.

## Refining an existing issue

When `$ARGUMENTS` pointed at an existing issue:

1. Read the issue, its comments, and any linked code.
2. Research as in Step 2, and discuss as in Steps 3–5, to sharpen the four
   headings and reconsider the slice.
3. Propose the body edits and any design comment; get approval.
4. Update the body with `gh issue edit` and/or post the comment. Do not ping the
   bot.
