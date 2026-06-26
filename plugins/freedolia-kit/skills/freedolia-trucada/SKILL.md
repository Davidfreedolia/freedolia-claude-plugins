---
name: freedolia-trucada
description: >
  Extreu els punts importants d'una conversa telefònica (o reunió) amb un client
  o lead a partir del text JA transcrit que t'enganxa l'usuari. Activa-la quan
  l'usuari demani resumir/buidar una trucada, treure'n els punts clau, accions o
  propers passos, o enganxi una transcripció i digui "treu-ne el que importa".
  Torna NOMÉS un resum estructurat en català, llest per copiar al CRM. Cost zero:
  treballa sobre el text donat, cap transcripció ni cap crida a IA/servei nou.
---

# Freedolia — buidatge de trucada de client

> Entrada: **text ja transcrit** que l'usuari enganxa (transcripció literal o les
> seves notes de la trucada). Sortida: **un sol resum estructurat en català**.
> No transcrius àudio, no crides cap servei, no escrius res a Supabase. Només llegeixes
> el text i en tregues el suc.

## 0. Regles d'or

- **Català per defecte** (CLAUDE.md). Si la trucada és en ES/FR/EN, resumeix igualment
  en català però marca l'idioma detectat del client a la capçalera (per a `lead_lang`).
- **Zero invenció.** Si una dada no surt al text (pressupost, data, nom…), posa-hi
  `—` o "no esmentat". Mai t'inventis xifres ni acords. És un error greu inflar un
  resum amb suposicions.
- **Decisiu i directe** (CLAUDE.md). Frases curtes, sense farciment. El David vol el
  gra, no la palla.
- **Verbatim per al que importa.** Compromisos de preu, terminis i objeccions clau:
  cita la frase literal entre cometes perquè no es deformi.
- **Mai PII sensible al resum** (IBAN, contrasenyes, números de targeta). Si surten al
  text, no els reprodueixis: posa-hi `[dada sensible omesa]`.

## 1. Què has d'extreure (en aquest ordre)

Omple cada bloc. Si un bloc queda buit, deixa'l amb `—` però no l'eliminis: l'absència
d'informació també és informació (p. ex. "no s'ha parlat de pressupost" és un senyal).

1. **Identificació** — nom, empresa, càrrec, contacte (email/tel si surten), idioma detectat.
2. **Què vol** — la necessitat real en 1–2 frases. El *problema*, no només el *producte* que demana.
3. **Abast / requisits** — funcionalitats, pàgines, integracions, plataformes concretes esmentades.
4. **Pressupost** — xifres exactes o rang. Sensibilitat al preu ("és car", "no hi ha problema").
5. **Terminis / urgència** — dates o deadlines concrets. Converteix sempre relatius a absoluts
   ("la setmana que ve" → posa la data segons `currentDate`).
6. **Objeccions / dubtes** — què el frena (preu, confiança, timing, comparant amb competència).
7. **Decisions / acords** — què s'ha tancat de debò durant la trucada.
8. **Propers passos** — accions concretes amb **responsable** i **data**. Distingeix què fa
   *nosaltres* de què fa *el client*. Si toca followup, proposa data segons la cadència
   del projecte: `+3d → +5d → +7d → +10d` (M-10).
9. **Temperatura** — calent / tebi / fred + una línia justificant-ho (senyals de compra reals).

## 2. Format de sortida (literal)

Torna exactament aquesta estructura en markdown. Res abans, res després (cap preàmbul tipus
"Aquí tens el resum"). Si algun bloc no aplica, deixa la línia amb `—`.

```
## 📞 Trucada — {nom o empresa} · {data de la trucada si es coneix}

**Client:** {nom} · {empresa} · {càrrec} · {idioma detectat: CA/ES/FR/EN}
**Contacte:** {email / telèfon o —}

**Vol:** {1–2 frases — el problema real}

**Abast:**
- {requisit / funcionalitat}
- …

**Pressupost:** {xifra o rang o "no esmentat"} — {sensibilitat al preu}
**Terminis:** {dates absolutes o —}

**Objeccions:**
- {objecció} → {com la podem rebatre, si és evident}

**Acordat:**
- {decisió presa}

**Propers passos:**
- [ ] {acció} — *Nosaltres* — {data}
- [ ] {acció} — *Client* — {data}
- Followup suggerit: {data segons cadència}

**🌡️ Temperatura:** {calent/tebi/fred} — {per què}

---
**Per al CRM:** status suggerit `{nou/contactat/proposta/client…}` · lead_lang `{CA/ES/FR/EN}` · proper followup `{data}`
> {1 frase verbatim clau de la trucada, entre cometes}
```

## 3. Casos límit

- **Text molt curt o ambigu:** no inflis. Omple el que hi ha i marca la resta amb `—`.
  Millor un resum honest de 5 línies que un d'inventat de 30.
- **Diversos interlocutors / multillead:** si el text barreja dues empreses o dos contactes,
  fes un bloc per cadascun.
- **Transcripció bruta (sense puntuació, "ehm", talls):** ignora el soroll, queda't amb el contingut.
- **Idioma barrejat:** resumeix en català; l'idioma detectat és el predominant del *client*.
- **Si l'usuari després vol desar-ho al lead:** això NO és aquesta skill. Diga-li que es pot
  fer (nota/activitat via el PAT), però aquesta skill només treu el resum a pantalla.

## 4. Lligams amb el pipeline

Aquesta skill és la **porta d'entrada** del kit de producte Freedolia. El resum que generes són,
literalment, "meeting notes" de qualitat → entren directes a la fase de descobriment del producte.

- Si l'usuari, després del resum, vol **definir un producte/feature** a partir de la trucada →
  passa-ho a **`freedolia-prd`** (idea/notes → PRD). Els blocs "Vol / Abast / Pressupost / Terminis"
  ja són matèria primera per al PRD.
- Si vol anar **de la trucada fins a un MVP** d'una tirada → **`freedolia-mvp`**, que orquestra
  trucada → estudi → PRD → spec → dev.
- No facis tu el salt automàticament: tornes el resum i **proposes** el següent pas. El David decideix.
