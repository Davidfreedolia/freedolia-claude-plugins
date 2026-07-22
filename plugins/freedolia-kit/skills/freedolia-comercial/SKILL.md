---
name: freedolia-comercial
description: >
  Munta el material de venda d'un producte Freedolia: el logo, el deck comercial de
  9 diapositives per a Claude Design i el guió cronometrat de 3 minuts per gravar amb
  Loom. Activa-la quan l'usuari digui "fem el deck", "necessito el logo", "el guió del
  vídeo", "material comercial", o quan un MVP ja tingui cara i calgui vendre'l. Va en
  PARAL·LEL a la via de producte, no després. Sortida: blocs per enganxar a Claude
  Design i un guió llest per llegir a càmera. Cost zero.
---

# Freedolia — material comercial d'un producte

> **Objectiu:** que un producte es pugui ensenyar i vendre el mateix dia que l'MVP té cara.
> Tres peces: **logo**, **deck de 9** i **guió de 3 minuts**. Aquesta skill no dissenya:
> **escriu els prompts** que ho generen i el guió que el David llegirà.
>
> Ja s'ha fet a **Hotel**, **Clínica**, **Tastia** i **StockPilot**. El patró és el mateix
> cada cop; el que canvia és la paleta, el vocabulari del sector i els números.

## 0. Regles d'or

- **Castellà a les slides i al guió.** El mercat és PIME espanyola. La documentació interna
  (notes, aquest procés) en català.
- **Els números surten de l'anàlisi sectorial**, literalment, amb les mateixes fonts. Si un
  client els busca, han d'aguantar. Mai arrodonir a l'alça.
- **Estètica deliberadament diferent per producte.** És el que fa que Hotel, Clínica i
  StockPilot no semblin el mateix producte repintat. La paleta ja la va fixar el prompt de
  Lovable: **reutilitza-la**, no en inventis una de nova.
- **El guardrail de negoci sempre visible**: *la IA propone, tú apruebas*. És l'argument que
  deixa tranquil qui signa.
- **Poc text per slide.** Frases curtes orientades a benefici, molt aire.

## 1. Ordre de treball

1. **Logo primer** (bloc A). Sense logo, la portada i el tancament del deck queden coixos.
2. **Deck després** (bloc B), dient explícitament a Claude Design que faci servir el logo
   generat a portada i tancament.
3. **Guió al final**, quan ja pots ensenyar producte real a pantalla.

Fitxer: `docs/comercial/instruccions_claude_design_<nom>.md` amb els dos blocs separats i
unes *notes per a tu* al final que **no** s'enganxen. El guió, a
`docs/comercial/guion-loom-3min.md`.

## 2. Bloc A — el logo

En castellà, per enganxar. Ha de dur:

- **Què és el producte** en una línia i per a qui, més la marca mare (Freedolia).
- **Què ha de transmetre** i, explícitament, **què no** (p. ex. *"NADA infantil"*).
- **Entrega**: isotip + logotip, i el símbol sol per a favicon/app icon.
- **Concepte del símbol**: combina el concepte del domini amb el de l'acció. A StockPilot,
  caixa/unitats (stock) + fletxa/pin/brúixola (pilot). Geomètric i minimalista, llegible en
  petit i **a una sola tinta**.
- **Wordmark**: quina tipografia i quina part destaca (`Stock` normal + `Pilot` destacat).
- **Paleta**: la mateixa que el producte, amb els hex escrits.
- **Variants**: fons fosc (principal), monocroma i fons clar. Pla, sense degradats pesats.

## 3. Bloc B — el deck de 9 diapositives

16:9, per presentar i exportar. L'esquelet està fixat i **no s'improvisa**:

| # | Slide | Contingut |
|---|---|---|
| 1 | **Portada** | Logo, nom, subtítol amb la promesa, kicker `FREEDOLIA · <VERTICAL>`, peu amb any |
| 2 | **El problema** | 4 targetes amb els dolors de l'anàlisi sectorial + **peu amb fonts** |
| 3 | **Què resolem** | `CONECTA · UNIFICA · ACTÚA` en 3 columnes + el guardrail destacat |
| 4 | **Es connecta amb el que ja tens** | Diagrama hub: el producte al centre, satèl·lits amb els sistemes reals del sector |
| 5 | **El producte** | Els N mòduls, icona + títol + una línia. Chips al peu (multi-X · 5 idiomes · tablet) |
| 6 | **Per què nosaltres** | 4 files amb check, cadascuna contra una alternativa real del mercat |
| 7 | **El retorn** | Stat callouts grans en monoespaiada + *"cifras del sector; las medimos contigo"* |
| 8 | **Integracions reals** | 3 columnes per maduresa: connexió directa / via partner / en incorporació |
| 9 | **Tancament** | Logo, *"Empieza con un piloto"*, 3 passos i contacte |

Notes que marquen la diferència:

- **Ritme de color entre slides.** Decideix-lo abans i escriu-lo al prompt (portada i
  tancament foscos, alternança al mig). Evita el look genèric i pla.
- **Slide 6 nomena competidors reals** i per què no serveixen per a la PIME (*"project44 y
  Shippeo son enterprise y caros"*). Sense noms, no convenç.
- **Slide 8 és la més fàcil de falsejar.** Si encara no tens la matriu d'integracions reals
  del sector, **digues que és provisional a les notes** i ofereix muntar-la abans. No la
  donis per bona.
- **Prohibit**: barres o franges decoratives, línies sota els títols, iconografia excessiva.

Si el producte ja és a producció, afegeix una slide de **prova en viu** amb QR reals a la
demo (patró Tastia): *"No es una maqueta: escanéalo y velo funcionando ahora."* És el que
més converteix.

## 4. El guió de 3 minuts (Loom)

Un fitxer llest per llegir, no un esquema. Regles:

- **~430 paraules** a 140-150 paraules/minut. Cronometra't; si passes de 3:00, retalla el
  bloc "per a qui".
- **Marques de temps a cada bloc** i, **entre claudàtors, què ensenyes a pantalla** mentre
  parles.
- Estructura provada:

| Temps | Bloc | Què fa |
|---|---|---|
| 0:00–0:20 | **Hook** | Qui ets i què veurà en 3 minuts. Una imatge concreta, no una definició |
| 0:20–0:45 | **El problema** | El dolor en llenguatge del client, no del producte |
| 0:45–1:35 | **Com funciona — demo** | El tros llarg. Producte real a pantalla, en passos numerats |
| 1:35–2:10 | **Per què és únic** | La combinació que ningú més té + *"hoy no es una maqueta"* |
| 2:10–2:40 | **Per a qui** | Els segments i el model de venda |
| 2:40–3:00 | **Tancament + CTA** | Per què ara, i què ha de fer qui ho mira |

- **Notes de gravació** al final, sempre: què obrir abans perquè carregui, **escalfar el
  backend** si Supabase pot estar adormit, i quins marcadors `[nom]` / `[email]` s'han de
  substituir.
- **La demo és l'estrella**: dedica-hi el bloc més llarg i assegura't que es veu el moment
  que impressiona.

## 5. Casos límit

- **Producte encara sense demo pública**: el guió es pot escriure igual, però marca els
  blocs de demo com a `[pendent d'URL]` i no prometis "está funcionando en producción".
- **Et demanen el .pptx directament**: es pot fer, però amb Claude Design el logo i l'acabat
  són millors. Digues el compromís i que triï el David.
- **Números que no tens**: no els inventis. Deixa el buit marcat i demana l'anàlisi sectorial.

## 6. Següent pas

Amb logo, deck i guió, el producte ja es pot ensenyar. En paral·lel, la via de producte
continua a `freedolia-aterratge` (si l'MVP encara és a Lovable) o a `freedolia-spec`
(si ja està aterrat i toca fer-lo funcionar de veritat).
