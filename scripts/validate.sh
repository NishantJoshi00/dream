#!/usr/bin/env bash
# Mechanical invariants for the dream skill. /dream runs this in Step 7 and
# must not commit unless it exits 0. Checks format only — never semantics.
set -u

dir="$(cd "$(dirname "$0")/.." && pwd)"
skill="$dir/SKILL.md"
dreams="$dir/references/dreams.md"
update="$dir/references/update.md"
fail=0
err() { echo "FAIL: $*" >&2; fail=1; }

[ -f "$skill" ] || { echo "FAIL: SKILL.md missing (exact case)" >&2; exit 1; }
[ -f "$dreams" ] || err "references/dreams.md missing"
[ -f "$update" ] || err "references/update.md missing"
[ ! -f "$dir/README.md" ] || err "README.md inside the skill folder (all docs go in SKILL.md or references/)"

# --- frontmatter ---
head -n1 "$skill" | grep -qx -- '---' || err "frontmatter must open with --- on line 1"
fm="$(awk 'NR==1{next} /^---$/{exit} {print}' "$skill")"
printf '%s\n' "$fm" | grep -q '^name: [a-z0-9][a-z0-9]*\(-[a-z0-9][a-z0-9]*\)*$' \
  || err "frontmatter name must be kebab-case"
case "$fm" in *'<'*|*'>'*) err "frontmatter contains XML angle brackets" ;; esac
desc="$(printf '%s\n' "$fm" | sed -n 's/^description: //p')"
if [ -z "$desc" ]; then
  err "frontmatter description missing"
else
  [ "${#desc}" -le 1024 ] || err "description exceeds 1024 characters (${#desc})"
  words=$(printf '%s' "$desc" | wc -w | tr -d ' ')
  [ "$words" -le 75 ] || err "description exceeds 75 words ($words)"
fi

# --- size limits ---
lines=$(wc -l < "$skill" | tr -d ' ')
[ "$lines" -le 300 ] || err "SKILL.md exceeds 300 lines ($lines)"
rulecount=$(grep -c '^- \*\*R' "$skill" || true)
[ "$rulecount" -le 30 ] || err "more than 30 active rules ($rulecount)"

# --- rule, evidence, and ledger line formats ---
awk '
  /^- \*\*R/ {
    if (pending) { print "FAIL: rule at line " pline " missing evidence line" > "/dev/stderr"; bad=1 }
    pending=1; pline=NR
    if ($0 !~ /^- \*\*R[0-9]+ \(p[3-5], n=[0-9]+\)\*\* When .+\.$/) {
      print "FAIL: malformed rule at line " NR " (want: - **R<n> (p<3-5>, n=<n>)** When <trigger>, <imperative>.)" > "/dev/stderr"; bad=1
    }
    match($0, /R[0-9]+/); id=substr($0, RSTART, RLENGTH)
    if (seen[id]++) { print "FAIL: duplicate rule id " id > "/dev/stderr"; bad=1 }
    next
  }
  pending && /^  evidence: [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] — .+/ { pending=0; next }
  pending && NF > 0 { print "FAIL: rule at line " pline " missing evidence line" > "/dev/stderr"; bad=1; pending=0 }
  /^## Ledger/ { inledger=1; next }
  inledger && /^## / { inledger=0 }
  inledger && /^[0-9]/ {
    if ($0 !~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] \| steering events: [0-9]+ \| added\/amended\/revived: [0-9]+\/[0-9]+\/[0-9]+ \| demoted\/forgotten: [0-9]+\/[0-9]+$/) {
      print "FAIL: malformed ledger line at " NR > "/dev/stderr"; bad=1
    }
  }
  END {
    if (pending) { print "FAIL: rule at line " pline " missing evidence line" > "/dev/stderr"; bad=1 }
    exit bad
  }
' "$skill" || fail=1

# --- dreams.md sections and probe coverage ---
if [ -f "$dreams" ]; then
  for section in '## Subliminal' '## Forgotten' '## Trigger probes'; do
    grep -qx "$section" "$dreams" || err "dreams.md missing section: $section"
  done
  for id in $(grep -o '^- \*\*R[0-9]*' "$skill" | grep -o 'R[0-9]*'); do
    grep -q "^load: $id — " "$dreams" || err "no load probe for active rule $id in dreams.md"
  done
  grep -q '^skip: ' "$dreams" || err "no skip probes in dreams.md"
fi

[ "$fail" -eq 0 ] && echo "OK: all invariants hold"
exit "$fail"
