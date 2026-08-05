#!/usr/bin/env bash
#
# FREEDOLIA · hook Stop — «has canviat el producte; el text que l'explica també?»
#
# Per què existeix. El 06/08/2026, a cursosdecatala.cat, vam descobrir que ni la
# FAQ ni el xatbot deien res dels enviaments —just el dia que n'havíem canviat el
# preu i els països— i que el manual de l'administració no coneixia mitja
# pantalla nova. No va ser mala fe: es canvia el producte i el text que
# l'explica es queda enrere, perquè viu en un altre fitxer i ningú no hi pensa.
#
# Què fa. Mira si la feina recent ha tocat el codi que la gent VEU. Si no, calla.
# Si sí, ho recorda un sol cop cada X minuts, per no ser pesat. No bloqueja res.
#
# S'instal·la amb la skill `freedolia-automatismes`. No el toquis a mà al
# projecte: torna-la a executar i el reinstal·la.

set -u

# ── On és el codi ────────────────────────────────────────────────────────────
# El guió viu a <arrel>/.claude/hooks/. Es miren TOTS els repos: l'arrel i les
# carpetes de dins. Un projecte de Claude pot contenir-ne més d'un —una còpia
# vella i la bona, o material a part del codi— i triar-ne un a l'atzar vol dir
# callar quan s'ha treballat a l'altre. Ens va passar a la primera prova.
ARREL="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

REPOS=""
[ -d "$ARREL/.git" ] && REPOS="$ARREL"
for d in "$ARREL"/*/; do
  [ -d "$d/.git" ] && REPOS="$REPOS
${d%/}"
done
[ -n "$REPOS" ] || exit 0

# Camins que compten com a «cara visible». Només els que EXISTEIXEN a cada repo,
# perquè el mateix guió serveixi per a un TanStack Start, un Next o el que vingui.
CANDIDATS="src/routes src/components src/content src/i18n src/pages app pages components content supabase/functions"
FINESTRA="${FREEDOLIA_HOOK_FINESTRA:-8 hours ago}"

TOCAT=""
REPO=""
while IFS= read -r r; do
  [ -n "$r" ] || continue
  PATRO=""
  for c in $CANDIDATS; do
    [ -d "$r/$c" ] && PATRO="${PATRO}${PATRO:+|}^${c}/"
  done
  [ -n "$PATRO" ] || continue
  T="$(
    cd "$r" 2>/dev/null || exit 0
    {
      git status --porcelain 2>/dev/null | sed 's/^...//'
      git log --since="$FINESTRA" --name-only --pretty=format: 2>/dev/null
    } | grep -E "$PATRO" | sort -u
  )"
  # Ens quedem el repo on s'ha treballat MÉS: és on és la feina de debò.
  if [ -n "$T" ] && [ "$(echo "$T" | wc -l)" -gt "$(echo "${TOCAT:-}" | grep -c .)" ]; then
    TOCAT="$T"; REPO="$r"
  fi
done <<EOF
$REPOS
EOF

[ -n "$TOCAT" ] && [ -n "$REPO" ] || exit 0

# ── Un sol avís cada X minuts ────────────────────────────────────────────────
# El segell viu dins de .git, que no es versiona mai.
MINUTS="${FREEDOLIA_HOOK_MINUTS:-180}"
SEGELL="$REPO/.git/freedolia-repas.stamp"
ARA=$(date +%s)
if [ -f "$SEGELL" ]; then
  ULTIM=$(cat "$SEGELL" 2>/dev/null || echo 0)
  [ $((ARA - ULTIM)) -lt $((MINUTS * 60)) ] && exit 0
fi
echo "$ARA" > "$SEGELL"

QUANTS=$(echo "$TOCAT" | wc -l | tr -d ' ')

# Només els llocs que existeixen de debò, per no enviar ningú a un fitxer que no hi és.
LLOCS=""
afegeix() { [ -e "$REPO/$1" ] && LLOCS="${LLOCS}${LLOCS:+, }$2 ($1)"; }
afegeix "src/content/faq.ts"        "la FAQ"
afegeix "src/content/chatbot.ts"    "el xatbot"
afegeix "src/routes/admin.tsx"      "el manual de l'admin"
afegeix "src/i18n/dictionaries.ts"  "els textos i el SEO"
[ -n "$LLOCS" ] || LLOCS="la FAQ, el xatbot, el manual i els textos"

MISSATGE="Repas de continguts pendent: s'han tocat $QUANTS fitxers de la cara visible. Abans de tancar, mira si cal actualitzar $LLOCS, i les dades estructurades de les pagines noves. En els tres idiomes."

# `systemMessage` ho ensenya a qui treballa; `additionalContext` ho posa al
# context del model. Cap dels dos atura res.
printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"%s"}}\n' \
  "$MISSATGE" "$MISSATGE"
