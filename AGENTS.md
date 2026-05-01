# AGENTS.md — Repo-Struktur und Konventionen

Diese Datei ist **nicht Teil der gerenderten MkDocs-Seite** (sie liegt außerhalb von `docs/`). Sie dient als Referenz für Menschen und Agenten, die die Doku erweitern. Folgt der [`AGENTS.md`-Konvention](https://agents.md/) für AI-Coding-Agents — wird aber gleichzeitig auch von menschlichen Contributors gelesen.

## Stack

- **Generator:** MkDocs mit dem Material-Theme (`mkdocs.yml`)
- **i18n:** `mkdocs-static-i18n` mit `docs_structure: folder`
  - Default-Locale: `de` (Inhalte direkt unter `docs/`)
  - EN-Locale: `en` (gespiegelte Struktur unter `docs/en/`)
- **Markdown-Erweiterungen:** `admonition`, `pymdownx.details`, `pymdownx.superfences`, `attr_list`, `md_in_html`, `tables`, `pymdownx.emoji`
- **Build:** `mkdocs build` / `mkdocs serve`

## Verzeichnislayout

```
.
├── mkdocs.yml                     # Site-Konfiguration, Nav, i18n
├── overrides/                     # Custom Theme-Templates
├── AGENTS.md                      # Diese Datei (nicht gerendert)
├── pdf/                           # PDF-Build-Pipeline (Pandoc + Typst)
│   ├── build.sh                   # entdeckt Produkte automatisch, baut alle PDFs
│   ├── preamble.typ               # Typst-Show-Rules + cover()/admonition() helpers
│   ├── admonitions.lua            # Pandoc-Filter: !!! div -> #admonition()
│   ├── images.lua                 # Pandoc-Filter: _dark -> hell, numeric width -> pt
│   ├── preprocess_admonitions.py  # MkDocs-Admonitions -> fenced divs
│   ├── read_frontmatter.py        # Frontmatter-Reader (von build.sh)
│   └── validate_products.py       # CI-Pflichtcheck pro Produkt
├── .github/workflows/pdf.yml      # baut PDFs, committet sie nach docs/assets/downloads/
└── docs/
    ├── index.md                   # Startseite (DE), Grid-Cards mit allen Produkten
    ├── stylesheets/
    │   └── extra.css
    ├── _template/                 # Skeleton zum Kopieren (nicht gerendert, exclude_docs)
    ├── assets/
    │   ├── logo.png
    │   ├── ce.png / ce_dark.png                # CE-Logo (hell fuer PDF, dunkel fuer Site)
    │   ├── unterschrift_jvt.png / *_dark.png   # Unterschrift Geschaeftsfuehrer
    │   ├── downloads/                           # generierte PDFs (vom pdf-Workflow committed)
    │   └── <produkt>/                           # produktspezifische Bilder
    ├── <PRODUKT>/                               # ein Ordner pro Produkt (UPPERCASE)
    │   ├── index.md                             # Frontmatter + Grid-Cards
    │   └── Manual/
    │       └── manual_*.md                      # Bedienungsanleitung-Slots
    ├── support/
    │   └── support.md
    ├── CNAME
    └── en/                                      # EN-Spiegelung der gesamten DE-Struktur
        ├── index.md
        ├── <PRODUKT>/
        │   ├── index.md
        │   └── Manual/
        │       └── manual_*.md
        └── support/
```

## Produktordner-Konvention

Jedes Produkt hat:

1. **`docs/<PRODUKT>/index.md`** mit Grid-Cards-Layout (siehe Vorlage unten)
2. **`docs/<PRODUKT>/Manual/manual_*.md`** für die Bedienungsanleitung
3. **Optional `docs/<PRODUKT>/API/...`** für zusätzliche Dokumente (siehe `INTERFACE/`)
4. **Optional `docs/assets/<produkt>/...`** für produktspezifische Bilder
5. **Spiegelung unter `docs/en/<PRODUKT>/...`** für die englische Übersetzung

Ordnernamen sind **UPPERCASE ohne Leerzeichen / Bindestriche** (`PANC`, `LAPTEQPLUS`, `INTERFACE`, `LAPTEQPLUSATMOSPHERE`, `LAPTEQPLUSELEVATION`).

Ein Verzeichnis-Prefix `_` (z. B. `docs/_template/`) wird sowohl von MkDocs (`exclude_docs:` in `mkdocs.yml`) als auch vom PDF-Build (`pdf/build.sh`) als „nicht-publizieren" interpretiert. Nutze diese Konvention für Skeletons / interne Snippets, die im Repo bleiben sollen, aber nicht auf der Site landen dürfen.

## Frontmatter in `docs/<PRODUKT>/index.md`

Pflicht-Felder (vom PDF-Build und vom Validator gelesen):

```yaml
---
title: LAP-TEQ PLUS                          # Pflicht — Produktname auf PDF-Cover und im Browser-Tab
cover_image: assets/laptep-plus/hero.jpg     # Optional — Bild unter Logo aufs Cover
---
```

- `title`: Pflicht. Wird vom PDF-Cover als großer Titel gesetzt und an den deutschen Site-Header durchgereicht. Der `# TEQSAS …`-H1 darunter bleibt.
- `cover_image`: optional, Pfad **relativ zu `docs/`** (z. B. `assets/atmosphere/atmosphere_cover.png`). Erscheint zwischen Vendor-Zeile und Title auf dem PDF-Cover. Falls weggelassen, ist das Cover nur Logo + Title + Subtitle.
- Die englische Spiegelung `docs/en/<PRODUKT>/index.md` darf einzelne Felder überschreiben (z. B. lokalisierter `title`); fehlt das Frontmatter, fällt der Build auf das deutsche Frontmatter zurück.
- Subtitle (`Bedienungsanleitung` / `User Manual`) kommt aus dem Build-Default — nicht aus dem Frontmatter.

Validierung läuft vor jedem PDF-Build via `pdf/validate_products.py`. Lokal:

```sh
python3 pdf/validate_products.py
```

## Manual-Slot-Konvention

Die Manual-Dateien folgen einem festen Slot-Schema, das sich an den Nav-Kategorien (Einstieg / Betrieb / Service / Referenz) orientiert. Das Heading **`# N Titel`** im Markdown verwendet die **Slot-Nummer**, nicht die PDF-Kapitel-Nummer.

| Datei            | Slot-Bedeutung                  | Nav-Kategorie | Pflicht? |
|------------------|---------------------------------|---------------|----------|
| `manual_1.md`    | Bevor Sie beginnen              | Einstieg      | ja       |
| `manual_2.md`    | Zu Ihrer Sicherheit             | Einstieg      | ja       |
| `manual_3.md`    | Produktbeschreibung             | Einstieg      | ja       |
| `manual_4.md`    | Inbetriebnahme                  | Betrieb       | ja       |
| `manual_5.md`    | Bedienung                       | Betrieb       | optional |
| `manual_6.md`    | Reinigung und Pflege            | Betrieb       | ja       |
| `manual_7.md`    | Störungen und Hilfe             | Service       | ja       |
| `manual_8.md`    | Kalibrierung (oder ähnlich)     | Service       | optional |
| `manual_9.md`    | Lagerung                        | Service       | optional |
| `manual_10.md`   | Entsorgung                      | Service       | ja       |
| `manual_11.md`   | Technische Daten                | Referenz      | optional |
| `manual_ce.md`   | (EU/EG-)Konformitätserklärung   | Referenz      | ja       |

Nicht-zutreffende Slots werden weggelassen — z. B. hat `INTERFACE/` kein `manual_8.md` und kein `manual_9.md`.

Der Slot 8 (`manual_8.md`) wird nicht zwingend für „Kalibrierung" verwendet — bei `LAPTEQPLUSELEVATION/` enthält er „Trigonometrische Korrektur / Längeneinheit". Der Nav-Eintrag in `mkdocs.yml` benennt den Slot dann passend (siehe `nav_translations`).

## Grid-Cards-Vorlage (Produkt-`index.md`)

```markdown
# TEQSAS <PRODUKTNAME>

<!-- TODO: Produktbild <PRODUKTNAME> hier einfügen, sobald hochgeladen -->

Dies ist die Sammlung der Dokumente für das TEQSAS <PRODUKTNAME>.

<div class="grid cards" markdown>

-   :octicons-book-16: __Bedienungsanleitung__

    ---

    [Zum Handbuch](./Manual/manual_1.md)

-   :octicons-shield-check-16: __CE-Konformität__

    ---

    [Zur Erklärung](./Manual/manual_ce.md)

-   :octicons-graph-16: __Technische Daten__

    ---

    [Zu den Daten](./Manual/manual_11.md)

</div>
```

Übliche Octicons im Repo: `:octicons-package-16:` (Produkt-Cards auf Startseite), `:octicons-book-16:` (Manual), `:octicons-shield-check-16:` (CE), `:octicons-graph-16:` (Technische Daten), `:octicons-code-16:` (API/Code), `:octicons-info-16:` (Hinweise).

## Admonition-Konvention (deutsche Labels)

```markdown
!!! danger "Gefahr"
    **Unmittelbare Lebens- oder Verletzungsgefahr!**

    Unmittelbar gefährliche Situation, die Tod oder schwere Verletzungen zur Folge haben wird.

!!! warning "Warnung"
    **Wahrscheinliche Lebens- oder Verletzungsgefahr!**

    Allgemein gefährliche Situation, die Tod oder schwere Verletzungen zur Folge haben kann.

!!! warning "Vorsicht"
    **Eventuelle Verletzungsgefahr!**

    Gefährliche Situation, die Verletzungen zur Folge haben kann.

!!! abstract "Achtung"
    **Gefahr von Geräteschäden!**

    Situation, die Sachschäden zur Folge haben kann.

!!! info "Hinweis"
    Informationen, die zum besseren Verständnis der Abläufe gegeben werden.
```

Konvention:
- **Erste Zeile** im Admonition ist meist eine **fett gesetzte** Zusammenfassung mit Ausrufezeichen
- Der danach folgende Fließtext ist eingerückt (4 Spaces)
- Bullets innerhalb eines Admonition werden mit `*` und 4-Space-Einrückung eingebettet

## Bilder

- **Pfade:** relativ zur Markdown-Datei (z. B. `../../assets/...` aus `Manual/manual_*.md`)
- **Ausrichtung:** `{ align=right }` (Material-Theme-Attribut über `attr_list`)
- **Title-Tooltip:** `![Alt](pfad "Tooltip-Text")`
- **Beispiel CE-Seite:**
  ```markdown
  ![CE](../../assets/ce_dark.png "CE"){ align=right }
  ![Unterschrift](../../assets/unterschrift_jvt_dark.png){ align=right }
  ```
- **Fehlende Bilder:** als HTML-Kommentar an der Stelle einfügen, wo sie hingehören:
  ```markdown
  <!-- TODO: Abbildung "<Beschreibung>" einfügen -->
  ```

## Listen, Tabellen, sonstige Formatierung

- **Bullet-Listen:** `*` mit Leerzeichen (z. B. `* Text`). Geschachtelt mit 4-Space-Einrückung.
- **Tabellen:** Standard-Markdown mit `|`-Trennern und Header-Trennlinie aus `---`.
- **Inline-Code / UI-Texte:** Backticks für technische Bezeichner (`„no sensor"`); UI-Texte aus dem Display in deutschen Anführungszeichen `„text"`.
- **Kein Frontmatter** in Manual-Dateien.

## Cross-Page-Links

- Innerhalb eines Manuals (Kapitel-Links): `[Kapitel 8](manual_8.md)`
- Mit Anker auf Subsection: `[Kapitel 3.2](manual_3.md#32-ihr-gerat-im-uberblick)` (Anker = Slugified Header)
- Auf Assets: `../../assets/<datei>`

## `mkdocs.yml`

Wichtige Sektionen, wenn ein neues Produkt dazukommt:

1. **`nav: → Produkte:`** — neuer Block in der Form
   ```yaml
   - 'Anzeigename Produkt':
     - <PRODUKT>/index.md
     - Bedienungsanleitung:
       - Einstieg:
         - Bevor Sie beginnen: <PRODUKT>/Manual/manual_1.md
         - ...
       - Betrieb:
         - ...
       - Service:
         - ...
       - Referenz:
         - ...
   ```
   Reihenfolge im Nav: alphabetisch nach Produktfamilie sinnvoll gruppieren (z. B. alle `LAP-TEQ PLUS *` zusammen).
2. **`plugins: → i18n: → languages: → en: → nav_translations:`** — pro neuer Section-Bezeichnung im Nav, die im Default `de` deutsch ist und in `en` übersetzt werden soll.
3. **Keine** `nav:`-Sektion innerhalb der englischen Locale — der i18n-Plugin nutzt die deutsche Nav und ersetzt nur die Beschriftungen via `nav_translations`.

## i18n-Verhalten

- DE-Inhalte liegen unter `docs/<PRODUKT>/...`
- EN-Inhalte liegen unter `docs/en/<PRODUKT>/...` mit identischer Datei-Struktur
- Fehlt eine EN-Datei, fällt der Plugin (je nach Konfiguration) auf die DE-Variante zurück oder wirft einen Build-Warn — daher: **immer beide Sprachen pflegen**.
- Übliche Übersetzungen für Nav-Bezeichner stehen bereits in `mkdocs.yml`.

## Übersetzungs-Vokabular (für neue Inhalte)

Konsistente DE→EN-Übersetzungen für Admonition-Labels und Section-Titel:

| Deutsch | English |
|---|---|
| Gefahr | Danger |
| Warnung | Warning |
| Vorsicht | Caution |
| Achtung | Notice |
| Hinweis | Note |
| Bevor Sie beginnen | Before you begin |
| Zu Ihrer Sicherheit | For your safety |
| Produktbeschreibung | Product Description |
| Inbetriebnahme | Powering up |
| Bedienung | Usage |
| Reinigung und Pflege | Cleaning |
| Störungen und Hilfe | Issues and Help |
| Kalibrierung | Calibration |
| Trigonometrische Korrektur | Trigonometric Correction |
| Lagerung | Storage |
| Entsorgung | Disposal |
| Technische Daten | Technical Data |
| (EU/EG-)Konformitätserklärung | Regulations / EU Declaration of Conformity |

Servicecenter-Adresse (Otto-Hahn-Straße 20a, 50354 Hürth, Deutschland) wird auch in der englischen Version **nicht** übersetzt.

## PDF-Generierung

Jede Bedienungsanleitung wird zusätzlich als PDF gebaut und unter `docs/assets/downloads/<PRODUKT>_MANUAL_<LANG>.pdf` ins Repo committet. Das `MANUAL`-Token im Filename ist das Asset-Typ-Token aus der Downloads-Konvention (siehe Abschnitt „Downloads-Bereich").

**Pipeline:** Pandoc 3.5 parst das Markdown → Typst 0.12 setzt das PDF.

- **Trigger:** `.github/workflows/pdf.yml` läuft auf jedem `push` nach `main` und auf jedem `pull_request`.
- **Build-Skript:** `pdf/build.sh` entdeckt Produkte automatisch (jedes `docs/<X>/Manual/`, ausser `_*`-Verzeichnisse und der EN-Spiegel). Die Kapitel-Reihenfolge ergibt sich aus `find … -name 'manual_[0-9]*.md' | sort -V`, gefolgt von `manual_ce.md` als Anhang.
- **Cover:** Logo + `vendor: TEQSAS PRODUCTS` + optionales `cover_image` aus dem Frontmatter + `title` + Subtitle (je Sprache `Bedienungsanleitung` / `User Manual`). Definiert in `pdf/preamble.typ` (`#cover()` helper).
- **Schriftart:** Ubuntu / Ubuntu Mono (via `apt install fonts-ubuntu` im Workflow).
- **Admonitions:** `pdf/preprocess_admonitions.py` wandelt MkDocs-Syntax `!!! type "title"` in Pandoc-Fenced-Divs `::: {.admonition .type title="…"}` um. `pdf/admonitions.lua` rendert diese in farbige Boxen mit Norm-Farben:

  | Signalwort | Farbe | Quelle |
  |---|---|---|
  | Gefahr   | Rot #C8102E    | ANSI Z535.6 / ISO 3864 / RAL 3001 |
  | Warnung  | Orange #ED760E | ANSI Z535.6 / ISO 3864 / RAL 2010 |
  | Vorsicht | Gelb #F9A800   | ANSI Z535.6 / ISO 3864 / RAL 1003 |
  | Hinweis / Achtung | Blau #0072CE | ANSI Z535.6 / ISO 3864 / RAL 5005 |

  Der Lua-Filter dispatcht **primär über den Title** (nicht die MkDocs-Klasse), weil `!!! warning "Vorsicht"` und `!!! warning "Warnung"` dieselbe Klasse haben aber unterschiedliche Norm-Stufen.
- **Bilder:** `pdf/images.lua` ersetzt `_dark.png/jpg` Suffixe durch die hellen Originale (im PDF brauchen wir helle Bilder auf weissem Papier statt der dunklen Theme-Varianten der Site). Ausserdem hängt es `pt` an numerische `width="480"`-Attribute, weil Typst keine `px`-Einheit kennt.
- **Validator:** `pdf/validate_products.py` prüft vor dem Build, dass jedes Produkt `title` im Frontmatter hat, dass `cover_image` (falls gesetzt) existiert, und dass die Pflicht-Slots `manual_1.md`, `manual_2.md`, `manual_3.md`, `manual_ce.md` da sind. Fehlende EN-Spiegel sind Warnungen, kein Fehler.
- **Self-Reporting:** Bei einem fehlgeschlagenen Lauf in einem `pull_request`-Event postet der Workflow ein Comment mit den letzten Zeilen aus `install.log`, `validate.log` und den fehlgeschlagenen Produkt-Logs. Kein Hin-und-Her-Kopieren von CI-Logs nötig.
- **Push-back:** Nach erfolgreichem Build kopiert der Workflow `build/*.pdf` nach `docs/assets/downloads/` und committet als `github-actions[bot]`. Die `.gitignore` enthält dafür eine explizite Negation, weil das generische `downloads/`-Pattern sonst greift. `paths-ignore: docs/assets/downloads/**` verhindert die Endlos-Schleife.

**Lokal bauen:**

```sh
# einmalige Installation
sudo apt install pandoc fonts-ubuntu
curl -fsSL https://github.com/typst/typst/releases/download/v0.12.0/typst-x86_64-unknown-linux-musl.tar.xz | tar -xJ -C /tmp
sudo mv /tmp/typst-*/typst /usr/local/bin/

# Build
python3 pdf/validate_products.py && bash pdf/build.sh
```

PDFs landen in `build/`. Logs in `build/<PRODUKT>_<LANG>.log` für die Diagnose.

## Downloads-Bereich

Die Site hat eine zentrale Downloads-Seite (`/downloads/` bzw. `/en/downloads/`) mit Volltext-Suche über alle öffentlichen Asset-Dateien unter `docs/assets/downloads/`.

**Filename-Konvention (Pflicht):**

```
<PRODUKT>_<TYP>_<LANG>.<ext>
```

- `<PRODUKT>` — UPPERCASE-Code wie im Verzeichnisnamen (z. B. `LAPTEQPLUSATMOSPHERE`).
- `<TYP>` — UPPERCASE-Token, beschreibt die Asset-Sorte. Bisher gibt es `MANUAL`. Konventionen für künftige Typen: `DATASHEET`, `DRAWING`, `FIRMWARE`, `STEP` o. ä.
- `<LANG>` — `DE` oder `EN`.
- `<ext>` — beliebige Dateiendung (`pdf`, `zip`, `step`, `dxf`, …). Endung landet im Manifest-Feld `ext` und kann später als Filter/Badge genutzt werden.

Beispiele:

```
LAPTEQPLUSATMOSPHERE_MANUAL_DE.pdf
PANC_DATASHEET_EN.pdf
LAPTEQPLUS_FIRMWARE_DE.zip
```

Dateien ohne Typ-Token (Altform `<PRODUKT>_<LANG>.<ext>`) oder mit unbekanntem Sprach-Token werden vom Hook **übersprungen** und mit `WARNING` ins Build-Log geschrieben — Konventionsbrüche werden so sichtbar.

**Architektur:**

- **`hooks/downloads_manifest.py`** — MkDocs-Hook (in `mkdocs.yml` unter `hooks:`), läuft beim Build. Scannt `docs/assets/downloads/`, parst Filenames nach obiger Konvention, liest den `title:` aus dem jeweiligen Produkt-`index.md` und schreibt ein generiertes `assets/downloads/manifest.json` ins Site-Output (kein Commit nötig — wird bei jedem Build neu erzeugt). DE-Frontmatter dient als Fallback, falls EN-Frontmatter den `title:` nicht setzt.
- **`docs/downloads/index.md`** + **`docs/en/downloads/index.md`** — statische Seiten mit `<input id="download-search">` und `<div id="download-results">`. Kein hartkodierter Listen-Inhalt.
- **`docs/javascripts/downloads.js`** — global via `extra_javascript` geladen, no-op auf Seiten ohne `#download-results`. Lädt das Manifest, liest `?q=` aus der URL, filtert Substring-case-insensitive über `product`, `productTitle`, `type`, `file`, rendert je Produkt eine Card, je Datei eine Zeile mit DE/EN-Tag und Download-Button. URL wird live mit `history.replaceState` aktualisiert (bookmarkbar/teilbar).

**Verlinkung von Produktseiten:** In jeder `docs/<PRODUKT>/index.md` (DE + EN) ist eine Grid-Card „Download" vorhanden, die nach `../downloads/index.md?q=<Begriff>` verlinkt. Der Suchbegriff ist so gewählt, dass er Substring des `productTitle` ist (z. B. `?q=Atmosphere` matcht „LAP-TEQ PLUS Atmosphere"). Die `index.md`-Form im Pfad ist nötig, damit MkDocs `--strict` den Link nicht als „unrecognized" warnt — gerendert wird ohnehin auf `…/downloads/?q=…`.

**Bei einem neuen Produkt:** Sobald der `pdf`-Workflow das `<PRODUKT>_MANUAL_<LANG>.pdf` nach `docs/assets/downloads/` committet, taucht der Eintrag automatisch in der Downloads-Liste auf — keine Anpassung an `downloads/index.md` oder am Hook nötig. Nur die Download-Grid-Card im jeweiligen Produkt-`index.md` ergänzen (gehört zur Checkliste unten).

**Neue Asset-Typen (Zukunft):** Datei mit Namen `<PRODUKT>_<TYP>_<LANG>.<ext>` nach `docs/assets/downloads/` legen — entweder manuell committet oder von einem zusätzlichen CI-Workflow analog zu `pdf.yml` erzeugt. Der Hook erkennt das Token automatisch und zeigt es title-cased als Badge (z. B. `DATASHEET` → `Datasheet`). Lokalisierte Labels (z. B. „Datenblatt") können in `docs/javascripts/downloads.js` im `I18N`-Objekt unter `type:` ergänzt werden — ohne Eintrag fällt das Frontend auf das Roh-Token zurück.

## Skeleton: neues Produkt anlegen

`docs/_template/` ist eine vollständige Kopiervorlage. Vorgehen:

```sh
cp -r docs/_template docs/<NEUES_PRODUKT>
cp -r docs/_template docs/en/<NEUES_PRODUKT>
```

Dann in beiden `index.md` das Frontmatter ausfüllen (`title:` ist Pflicht, `cover_image:` optional) und die `Manual/manual_*.md`-Slots befüllen. Slots, die nicht zutreffen, einfach löschen. Beim nächsten CI-Lauf entdeckt `pdf/build.sh` das neue Verzeichnis automatisch und produziert die PDFs.

## Checkliste: Neues Produkt hinzufügen

- [ ] `cp -r docs/_template docs/<PRODUKT>` und `cp -r docs/_template docs/en/<PRODUKT>` (UPPERCASE, keine Leerzeichen)
- [ ] In **beiden** `index.md` Frontmatter ausfüllen: `title:` (Pflicht), optional `cover_image:`
- [ ] Manual-Slots befüllen (nur die zutreffenden — siehe Slot-Tabelle); überzählige Slots aus dem Template löschen
- [ ] Inhalte aus Original-Quelle (PDF) **wortgetreu** übernehmen — nichts erfinden, nichts auslassen
- [ ] Admonitions im richtigen Typ verwenden (Gefahr/Warnung/Vorsicht/Achtung/Hinweis)
- [ ] `<!-- TODO: Abbildung ... -->` für noch nicht vorhandene Bilder einfügen
- [ ] `mkdocs.yml` `nav: → Produkte:` neuen Block ergänzen
- [ ] `mkdocs.yml` `nav_translations:` für ggf. neue Section-Beschriftungen ergänzen
- [ ] `docs/index.md` Grid-Card-Eintrag hinzufügen
- [ ] `docs/en/index.md` Grid-Card-Eintrag hinzufügen
- [ ] In `docs/<PRODUKT>/index.md` und `docs/en/<PRODUKT>/index.md` jeweils eine Grid-Card „Download" mit Link `../downloads/?q=<Suchbegriff>` ergänzen (Suchbegriff = Substring des Produkt-`title:`, z. B. `Atmosphere`, `Elevation`)
- [ ] Bilder unter `docs/assets/<produkt>/` ablegen, falls vorhanden
- [ ] `python3 pdf/validate_products.py` lokal grün — keine Errors
- [ ] Lokal `mkdocs build --strict` ausführen — keine Errors / Warnings akzeptieren
- [ ] Lokal `mkdocs serve` und im Browser stichprobenhaft prüfen (Sidebar, Cards, Verlinkungen, CE-Bilder)
- [ ] Commit auf passenden Feature-Branch, Push, ggf. PR — der `pdf`-Workflow generiert beim grünen Lauf `<PRODUKT>_MANUAL_DE.pdf` und `<PRODUKT>_MANUAL_EN.pdf` in `docs/assets/downloads/`

## Existierende Produkte (Stand: dieses Repo)

- `PANC/` — TEQSAS PAN-C
- `LAPTEQPLUS/` — LAP-TEQ PLUS (Display + INCLINOMETER)
- `LAPTEQPLUSATMOSPHERE/` — LAP-TEQ PLUS Atmosphere (Temperatur/Feuchte-Sensor)
- `LAPTEQPLUSELEVATION/` — LAP-TEQ PLUS Elevation (Lasersensor zur Höhenmessung)
- `INTERFACE/` — LAP-TEQ PLUS INTERFACE (mit zusätzlicher API-Doku unter `INTERFACE/API/`)
