# /dream — end-of-session update procedure

You are updating the dream skill from this session's evidence. You are mining **steering events**: every point where the operator redirected you. Read both `SKILL.md` and `references/dreams.md` (both in this skill's directory) before writing anything. When finished, commit if the skill lives in a git repository.

The purpose of every edit you make: reduce the number of times the operator has to steer, session over session. A rule is a miniature skill — a trigger condition plus an instruction, written as "when X, do Y" so the working agent recognizes the *situation* in which it applies. When a rule fails, the fault is usually the trigger (too vague or too narrow to fire at the right moment), not the taste behind it.

## Step 1 — collect steering events

Scan the full session for:

- Corrections of approach ("no, do X instead", re-scoping, rejected plans)
- Style/format/verbosity complaints ("too verbose", "stop explaining", "don't format like this")
- Repeated reminders — anything the operator had to say that an active rule should have prevented (a rule *failure*: the strongest signal)
- Explicit "always"/"never"/"remember this" statements
- Approvals and "yes, exactly" moments — positive signal for what to preserve
- Conflicts the working agent flagged between a Rule and a direct instruction

## Step 2 — determine which classes of work were in play

List the `###` classes this session actually touched. Rules whose class was not in play receive no priority change of any kind this run.

## Step 3 — score

Apply fixed integer deltas. Every priority change gets a one-line justification in your reply — no silent arithmetic.

| event | delta |
|---|---|
| new rule (no active or subliminal match) | enters at p3 |
| steering event confirms an existing rule, or explicit "always"/"never" | +2 |
| rule violated → amend, since the rule mattered but failed to bite | +1 |
| class in play, rule inert (not confirmed, not violated, no sign it did work) | −1 |
| class not in play | 0 |
| operator directly contradicted the rule | −3 |

Cap at 5, floor at −1. Notes:

- A violation is a **boost**, never a decay: the operator steering on a rule's territory proves the rule matters; the rule failed to bite. When amending, **diagnose the trigger first**: in most failures the taste was right but the "when <condition>" clause was too vague or too narrow to fire at the moment it was needed. Rewrite the trigger so it would have fired in this session's situation; touch the imperative only if the taste itself was wrong. Then +1.
- Absence of signal in an untouched class is zero evidence, not weak negative evidence. This is why chaotic or rushed sessions can't silently erode good rules.
- Before adding any new rule, search `## Subliminal` in dreams.md for a matching pattern. A fresh steering event matching a subliminal rule **revives** it: restore to SKILL.md at p3, keep its full evidence history, increment n, note the revival. Revival requires an observed event — never mere passage of time.
- Check `## Forgotten` epitaphs too. Re-introducing a forgotten rule requires explicitly citing the epitaph and justifying why the situation changed.
- Every new or amended rule must pass two tests before you write it: (a) *trigger test* — would the working agent, reading only the "when" clause, recognize this session's situation as a match? (b) *pre-emption test* — would an agent following the full rule have made this session's correction unnecessary? If either fails, rewrite until both pass.

## Step 4 — apply band transitions

Priority bands: **active** 3–5 (rendered in SKILL.md, loaded every session), **subliminal** 0–2 (full body preserved in dreams.md, invisible to the working agent), **forgotten** −1 (body deleted, epitaph only).

- Any active rule now < 3 → move its full body to `## Subliminal` in dreams.md with `demoted: <date>, <reason>`; remove from SKILL.md.
- Any subliminal rule now at −1 → delete its body; append an epitaph to `## Forgotten`.
- More than 30 active rules → demote the lowest-priority actives to subliminal until ≤ 30, even if they sit at p3. SKILL.md stays ≤ 300 lines. One skill, forever — never create a second skill or split the disclosed file.

## Step 5 — enforce the anti-rules

Check every candidate against `## Anti-rules` in SKILL.md before writing. When in doubt, don't capture — a wrong active rule costs more than a missed one.

## Step 6 — re-derive the description

The frontmatter description is the only part of this skill every future agent sees in every session: it is the recall hook, and it is **derived state** — never hand-edited, never containing anything unbacked by an active rule. After the Rules have settled, regenerate it:

- Keep the two fixed lead sentences (what this is + the load-when-matched warning). Regenerate only the trailing `Situations -` list.
- The list is the compressed union of the active rules' "when" clauses. While rules are few, enumerate situations; as they accumulate, merge them into class-level phrases — name the class of moment, and let the Rules hold the specifics. The whole description stays under ~75 words no matter how many rules exist.
- Phrase each situation as a recognizable task-time moment, not a capability. The test: an agent scanning it mid-task should think "my current task matches — skipping this risks a correction," not "this skill can do X."
- A demotion or forgetting that removes a rule also removes its situation from the description. Recall coverage must track active rules exactly — in both directions.
- Keep `## Trigger probes` in dreams.md in lockstep with the same edits: add one `load:` probe per new or revived rule (a concrete task-time moment its trigger should catch), delete the probe on demotion or forgetting, and add a `skip:` probe whenever this session showed the skill loading — or nearly loading — somewhere it shouldn't.
- Then desk-check the regenerated description against every probe: reading *only* the description, would an agent in the probe's situation load this skill? Every `load:` must pass, every `skip:` must fail. A failing probe indicts the description, not the rule — rewrite the description until all probes pass.

## Step 7 — ledger + commit

Append the ledger line to SKILL.md:

```
<date> | steering events: <n> | added/amended/revived: <n>/<n>/<n> | demoted/forgotten: <n>/<n>
```

If steering events haven't declined over the last ~5 entries, say which rules are failing and why — check first whether the failing rules share a symptom of trigger-vagueness.

Run `scripts/validate.sh` from the skill directory. It checks the mechanical invariants — frontmatter shape, description length, rule/evidence/ledger line formats, ≤ 30 active rules, ≤ 300 lines, one load probe per active rule. It must exit 0 before you commit; fix violations, never work around them.

If the skill directory is inside a git repository, commit only the skill directory:

```
git add <skill-dir> && git commit -m "dream: +<added> ~<amended> ^<revived> v<demoted> x<forgotten>, <n> steering events"
```

Reply with a diff-level summary: each rule touched, its priority movement with justification, and the steering event that caused it.

Zero steering events is a real outcome: apply Steps 2–4 (in-play classes still decay inert rules), append the ledger line, and if nothing else changed say "Clean session." Do not invent rules to look productive.
