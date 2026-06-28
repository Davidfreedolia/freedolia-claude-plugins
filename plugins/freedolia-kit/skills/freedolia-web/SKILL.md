---
name: freedolia-web
description: >
  Extreu tota la informació rellevant d'un client o lead a partir del seu WEB
  (en comptes d'una trucada): qui són, què fan, equip, serveis, com reserven/venen
  avui i quines necessitats es dedueixen. Activa-la quan l'usuari enganxi una URL
  d'un client i digui "mira qui són / treu el que tenen al web / busca les seves
  necessitats", o quan vulgui preparar una reunió a partir del web del client.
  Torna NOMÉS un brief estructurat en català, llest per copiar al CRM o per entrar
  a freedolia-prd. Cost zero: només WebFetch/WebSearch (free tier), cap IA ni servei nou.
---

# Freedolia — buidatge del web d'un client

> Entrada: **una o més URLs** d'un client o lead (web, fitxa de directori, xarxes).
> Sortida: **un sol brief estructurat en català**. És el bessó de `freedolia-trucada`
> però per a clients dels quals tens el web i no una conversa. No escrius res a Supabase,
> no crides cap servei de pagament: només llegeixes la web pública i en treus el suc.

## 0. Regles d'or

- **Català per defecte** (CLAUDE.md). Si el web és en ES/EN/FR, escriu el brief en català
  però marca l'idioma del web a la capçalera (per a `lead_lang`).
- **Zero invenció.** Si una dada no surt a cap font (preus, equip, horaris…), posa-hi `—`
  o "no publicat". Mai t'inventis xifres, noms ni serveis. Inflar el brief amb suposicions
  és un error greu — el David hi confia per preparar la reunió.
- **Cita la font.** Cada bloc de fets ha de ser traçable: enllaça les URLs d'on surt
  (web, Fresha/Treatwell/Booksy, Google, Instagram). Si una dada surt de dues fonts que
  es contradiuen, **nomena la contradicció** i digues quina sembla més fiable i per què.
- **Cost dur = 0.** Només `WebFetch` i `WebSearch` (free tier). Cap crida a IA generativa
  ni a Google Places. Si una font necessita login (privada), no la forcis: marca-la i tira
  amb les públiques.
- **Decisiu i directe** (CLAUDE.md). Frases curtes, el gra. Aquest brief alimenta un PRD,
  no és literatura.

## 1. Com extreure (en aquest ordre, robust a bloquejos)

Les webs sovint bloquegen el fetch directe (HTTP 403) o són JS-heavy. Sigues resilient:

1. **Prova `WebFetch`** sobre la home i les pàgines clau (about/sobre-nosaltres, equip,
   serveis, reserva, contacte, tallers/cursos).
2. **Si torna 403 o buit, cau a `WebSearch`** amb consultes dirigides (nom + ciutat + "equipo",
   "reservas", "horario", "cursos", noms de les persones de l'equip). Els snippets de cerca
   sovint contenen el que la web amaga.
3. **Mira les fonts secundàries**: fitxes de reserva (Fresha, Booksy, Treatwell), Google
   Business (horari, ressenyes, adreça), Instagram (equip, activitat, com diuen de reservar).
4. **Itera fins a tenir cada bloc de §2 cobert o marcat `—`.** No paris al primer fetch.

## 2. Què has d'extreure (en aquest ordre)

Omple cada bloc. Si un bloc queda buit, deixa'l amb `—`: l'absència també informa
(p. ex. "no tenen sistema de reserva propi" és una necessitat).

1. **Identificació** — nom comercial, persona/propietari, sector, ciutat/adreça, contacte
   (tel/email/IG/web), idioma del web, any de fundació si surt.
2. **Qui són / posicionament** — en 1–2 frases: què els fa diferents, to de marca, missió.
3. **Equip** — persones (noms + rol + especialitat). Clau per a verticals amb agenda per persona.
4. **Què fan / serveis** — serveis, productes, activitats (cursos, tallers, esdeveniments).
5. **Com operen avui** — com reserven o venen *ara* (telèfon, DM, formulari, plataforma X),
   horaris, multi-seu, preus si són públics. Detecta el **dolor operatiu**.
6. **Reputació** — valoració/ressenyes (Google, etc.) i temes recurrents del que en diuen.
7. **Necessitats detectades** — el pont al producte: 3–6 necessitats deduïdes dels fets de dalt.
   Cadascuna ancorada en una evidència ("reserven per DM → els cal reserva centralitzada").
8. **Encaix amb Freekalia/Freedolia** — quines capacitats nostres ho cobreixen i quin pla/forma
   sembla. Marca clarament què és **dedució** (no compromís).

## 3. Format de sortida (literal)

Torna exactament aquesta estructura en markdown. Res abans, res després (cap "Aquí tens…").
Si un bloc no aplica, deixa la línia amb `—`.

```
## 🌐 Web — {nom comercial} · {ciutat} · {data d'avui}

**Client:** {nom} · {persona/propietari} · {sector} · {idioma del web: CA/ES/FR/EN}
**Contacte:** {web} · {tel} · {email} · {IG/xarxes o —}

**Qui són:** {1–2 frases — posicionament real}

**Equip:**
- {nom} — {rol} — {especialitat}
- …

**Serveis / activitat:**
- {servei / producte / taller}
- …

**Com operen avui:** {reserva/venda actual} · horari {…} · {multi-seu? preus públics?}
> Dolor operatiu detectat: {1 frase}

**Reputació:** {valoració + nº ressenyes} — {temes recurrents}

**Necessitats detectades:**
1. {necessitat} — *evidència:* {fet del web que ho justifica}
2. …

**Encaix amb Freekalia/Freedolia (dedució):**
- {necessitat} → {capacitat nostra que ho cobreix}
- Pla/forma probable: {Solo/Pro/Enterprise o —}

---
**Per al CRM:** status suggerit `{nou/contactat/proposta…}` · lead_lang `{CA/ES/FR/EN}`
**Fonts:** {llista d'URLs consultades}
```

## 4. Casos límit

- **Web bloquejada del tot (403 a tot) i poca cerca:** omple amb el que donin els directoris i
  les xarxes, i marca explícitament què no s'ha pogut verificar. Millor un brief honest i curt
  que un d'inventat.
- **Cadena / multi-seu:** llista les seus si surten; marca el patró (franquícia, centres propis).
- **Persona = marca (autònom):** identificació i equip col·lapsen en una persona; deixa-ho clar.
- **Fonts contradictòries (horaris/adreces que no quadren entre web i Google):** nomena-ho i
  proposa quina sembla la vigent.
- **Idioma barrejat:** brief en català; l'idioma del web és el predominant de la home.
- **Si l'usuari vol desar-ho al lead:** això NO és aquesta skill (es pot fer via el PAT del CRM);
  aquí només treus el brief a pantalla.

## 5. Lligams amb el pipeline

Aquesta skill és una **porta d'entrada alternativa** del kit, bessona de `freedolia-trucada`:
quan no hi ha trucada però sí un web, el brief que generes és la mateixa matèria primera de
descobriment de producte.

- Si després l'usuari vol **aterrar un producte/feature** a partir del web →
  passa-ho a **`freedolia-prd`** (el brief "Qui són / Serveis / Necessitats / Encaix" ja és
  matèria primera del PRD; passa'l com a `args`).
- Si vol anar **del web fins a un MVP** d'una tirada → **`freedolia-mvp`**, que orquestra el
  camí sencer (ara amb web o trucada com a entrada).
- No facis tu el salt automàticament: tornes el brief i **proposes** el següent pas. El David decideix.
