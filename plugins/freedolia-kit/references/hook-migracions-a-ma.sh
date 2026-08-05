#!/usr/bin/env bash
#
# FREEDOLIA · hook PostToolUse — «acabes d'escriure una migració».
#
# Per què existeix. A Freedolia les migracions s'apliquen A MÀ per l'SQL Editor
# de Supabase, MAI amb `db push`: el remot té l'historial per data i les nostres
# van numerades, o sigui que un `db push` les reaplicaria totes. És una regla que
# hem hagut de recordar més d'un cop, i el moment de recordar-la no és quan ja
# s'ha fet: és just quan es crea el fitxer.
#
# Què fa. Quan s'escriu un fitxer nou a `supabase/migrations/`, ho diu. Res més.
# No bloqueja, no toca res, no mira el contingut.
#
# S'instal·la amb la skill `freedolia-automatismes`.

set -u

# El camí del fitxer arriba pel JSON de l'entrada.
CAMI="$(cat | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
[ -n "$CAMI" ] || exit 0

# Barres cap endavant o cap enrere, tant li fa.
NORM="$(printf '%s' "$CAMI" | tr '\\' '/')"
case "$NORM" in
  *supabase/migrations/*.sql) ;;
  *) exit 0 ;;
esac

FITXER="$(basename "$NORM")"

MISSATGE="Migracio nova: $FITXER. Recorda que a Freedolia s'apliquen A MA per l'SQL Editor de Supabase i MAI amb db push (reaplicaria totes les migracions al remot). Passa-li l'SQL sencer al David en un bloc de codi, amb la ruta."

printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' \
  "$MISSATGE" "$MISSATGE"
