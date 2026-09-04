---
name: freedolia-noticia
description: >
  Converteix el que passa de debò a la clienta —un WhatsApp entusiasmat, un correu
  d'un tercer, una foto— en una notícia publicable al blog: verificada, en la seva
  veu, amb imatge legal, trilingüe i sense filtrar dades privades de ningú.
  Activa-la quan arribi material per publicar ("cal que ho expliquis al web", "fes-ne
  una notícia", captures d'una fita, un premi, una donació, una presentació). El
  lliurable del primer torn és un ESBORRANY: no es publica res sense vistiplau.
---

# Freedolia — Notícies del blog

**Objectiu:** que la clienta pugui explicar el que ha aconseguit **sense que publiquem cap
cosa que no sigui certa, ni cap dada que no sigui seva**.

## 0. Regles d'or

- **Català**, primera persona, la seva veu. Abans d'escriure, llegeix dos articles seus del
  blog i imita'n el to: no el nostre.
- **L'entusiasme és seu; la precisió és nostra.** Ella escriurà «ja es pot consultar a la
  biblioteca» quan fa dues hores que ha deixat els llibres al taulell. Redacta el que és
  cert **avui**, no el que ho serà. Si la frase depèn d'un tercer (una biblioteca, un
  jurat, un mitjà), escriu-la de manera que segueixi sent certa si aquell tercer no fa res.
- **Correspondència privada, mai.** Un correu que li ha escrit algú és d'aquell algú:
  telèfons, adreces, signatures institucionals i frases literals queden fora. Els **noms**
  i el **fet** sí, quan la persona hi actua en la seva funció pública. Si val la pena
  citar-lo, es demana permís abans; no després.
- **Sense foto no hi ha notícia** (l'admin ho impedeix, i amb raó). Vegeu §2.
- **Trilingüe**: CA original + ES + EN, com tot el blog.
- **Esborrany primer.** Es crea amb `published: false` i s'ensenya. Publica **només** amb
  el vistiplau explícit del David.

## 1. Procés

### Pas 1 — Separar els fets de l'emoció

Buida el material en tres piles, i digue-les en veu alta al resum:

| Pila | Què hi va |
|---|---|
| **Fets verificables** | Dates, llocs, noms, quantitats. Van a la notícia |
| **El que ella sent** | «un somni fet realitat», «un honor». Va a la notícia, com a seu i en primera persona |
| **El que encara no és cert** | Tot el que depèn que un tercer faci alguna cosa. Es reescriu o s'espera |

### Pas 2 — La imatge

Per ordre de preferència:

1. **Una foto seva de l'acte.** Demana-la sempre primer: cap foto d'arxiu val el que una de
   real.
2. **Wikimedia Commons**, amb llicència lliure comprovada a l'API (`extmetadata`:
   `LicenseShortName`, `Artist`). Ha de ser **d'allò**: la biblioteca de què parla, no una
   biblioteca qualsevol.
3. Res més. Una foto que no és del que s'explica enganya més que no pas cap foto.

Sempre: **baixar-la i pujar-la al nostre magatzem** (`blog/actualitat/`), mai enllaçar-la
d'on és — les portades que penjaven d'un servidor de tercers ens van caducar totes
[[pagina-recursos-cursosdecatala]]. I el **crèdit al peu de l'article**, amb autor i
llicència, tal com el demana la llicència i com ja el porten els altres articles.

### Pas 3 — Escriure

- **Títol**: el fet, concret. Ni «Una gran notícia» ni superlatius.
- **Entradeta**: dues frases. Qui, què, i per què importa.
- **Cos**: 4–6 paràgrafs curts. El fet, qui hi ha darrere, l'agraïment si escau, i el
  tancament personal seu.
- El títol d'un llibre seu va **sempre en cursiva** (ho fa sol l'ajudant del web).

### Pas 4 — Ensenyar-ho, i esperar

Presenta el text sencer al xat —no un resum— i, a part:

- **què has deixat fora i per què** (dades privades, frases no verificades),
- **què falta per publicar** (una foto, un permís, una confirmació),
- **on més tocarà tocar** quan es publiqui (credencials de Qui soc, quadre d'aval d'un
  llibre, `llms.txt`).

### Pas 5 — Publicar (amb el vistiplau)

1. `published: true` + `published_at`.
2. Verifica **des de fora**: 200 en els tres idiomes, que surti a la llista d'actualitat, i
   que la imatge respongui amb el seu `content-type` de debò —no només amb un 200
   [[verificar-de-fora-no-de-dins]].
3. Propaga el que calgui a la resta del web.
4. Digues al David **què li ha d'explicar ell a la clienta**: sobretot, què no hem publicat
   i per què.

## 2. Estàndard de qualitat

La notícia està bé quan:

- Cap frase depèn que un tercer confirmi res que encara no ha confirmat.
- No hi ha ni un correu, ni un telèfon, ni una signatura de ningú.
- La imatge és del que s'explica, és nostra al magatzem i porta el crèdit.
- Existeix en els tres idiomes.
- Si la clienta la comparteix amb el protagonista de la història, no hi ha res que li faci
  passar vergonya.

## 3. Trampes conegudes

- **«Cal que ho expliquis al web!!!»** vol dir que ho expliquem bé, no de pressa.
- **La foto de la clienta amb dades a dins.** Una captura d'una fitxa interna pot portar el
  seu telèfon i els seus correus: es retalla abans de publicar.
- **Els noms i els càrrecs s'escriuen bé.** Un doctor mal escrit en una notícia
  d'agraïment és pitjor que no fer-la.
- **La notícia obliga la resta del web.** Si diu que un llibre és a una biblioteca, la
  fitxa del llibre ho ha de dir igual; si no, un dels dos menteix.
