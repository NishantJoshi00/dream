---
name: dream
description: Operator taste for this project, learned from past corrections. Load when the current task matches a situation below, or you will likely repeat a mistake the operator already corrected once. Situations - creating or structurally modifying a skill (layout, frontmatter, description, references).
---

# Dream — this project

This skill encodes the operator's accumulated taste for this project, learned from their steering interventions across sessions. It is the accountability contract: before finishing any task, check the work against the Rules below. It is updated only by `/dream`, never mid-task.

## Two modes

This skill has exactly two triggers. Know which one you are in.

1. **Recall — agent-triggered.** You (the working agent) loaded this skill because your current task matches a situation in the description — territory where an agent was corrected before. Hold the Rules in force while you work. In this mode you only *read* the skill — never edit it, and never read `references/`.
2. **Dream — human-triggered, end of session.** The operator explicitly invokes `/dream`. You stop being the working agent: ignore the rest of this file and follow `references/update.md`, which is the complete dreaming procedure. Never dream unprompted.

## How to apply (recall mode)

- Treat every Rule as a standing instruction with the same force as a direct user message.
- Each Rule is condition-shaped: a trigger situation plus an instruction. When its trigger situation occurs during your work, the rule is in force. Before declaring any task done, walk the Rules, identify which triggers fired, and fix violations *before* presenting — the goal is that the operator never has to say any of these things again.
- If a Rule conflicts with a direct instruction in the current session, the direct instruction wins; note the conflict so `/dream` can reconcile it.
- Do not read `references/dreams.md`. It is `/dream`'s working memory, not yours.

## Rules

<!-- Empty at creation. Rules are earned from real sessions via /dream — never seeded, never edited mid-task.
     Active rules only (priority 3–5). Exact format:

     - **R<n> (p<priority>, n=<times observed>)** When <trigger condition>, <imperative instruction>.
       evidence: <date> — <8–15 word quote or paraphrase of the steering that produced it>

     The trigger condition names the recognizable situation — the class of moment, artifact, or
     decision — phrased broadly enough to catch every instance and narrowly enough not to misfire.
     It is a retrieval cue, not a summary. The instruction is one testable imperative.
     Group rules under ### subheadings by class of work (e.g. ### Code, ### Communication,
     ### Process) as they accumulate — classes emerge from evidence, don't pre-create them. -->

### Process

- **R1 (p3, n=1)** When creating or structurally modifying a skill (SKILL.md layout, frontmatter, bundled references), read the skill-creator skill's guidance before writing.
  evidence: 2026-07-21 — "please consider using the skill-creator skill to understand the right way"

## Anti-rules

Things `/dream` must never capture:

- Environment-dependent failures (missing binaries, unset env vars, path mismatches). Capture the *fix* under a Rule if durable, never the failure.
- Negative capability claims ("X tool doesn't work"). These harden into stale refusals.
- Transient errors that resolved within the session. If a retry worked, the lesson is the retry pattern.
- One-off task narratives. A single task is not a class of work.
- Anything the operator said hypothetically or while brainstorming.

## Ledger

One line per `/dream` run: `<date> | steering events: <n> | added/amended/revived: <n>/<n>/<n> | demoted/forgotten: <n>/<n>`

This is the metric: **steering events per session should trend down.** If it doesn't over ~5 sessions, `/dream` must say so and hypothesize which rules are failing.

2026-07-21 | steering events: 2 | added/amended/revived: 1/0/0 | demoted/forgotten: 0/0
