# Repo-Struktur und Konventionen

Diese Datei ist **nicht Teil der gerenderten MkDocs-Seite** (sie liegt außerhalb von `docs/`). Sie dient als Referenz für Menschen und Agenten, die die Doku erweitern.

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
├── mkdocs.yml             # Site-Konfiguration, Nav, i18n
├── overrides/             # Custom Theme-Templates
├── STRUCTURE.md           # Diese Datei (nicht gerendert)
└── docs/
    ├── index.md           # Startseite (DE), Grid-Cards mit allen Produkten
    ├── stylesheets/
    │   └── extra.css
    ├── assets/
    │   ├── logo.png
    │   ├── ce.png / ce_dark.png            # CE-Logo für CE-Seiten
    │   ├── unterschrift_jvt.png / *_dark.png  # Unterschrift Geschäftsführer
    │   └── <produkt>/                       # produktspezifische Bilder
    ├── <PRODUKT>/                           # ein Ordner pro Produkt (UPPERCASE)
    │   ├── index.md                         # Produktübersicht (Grid-Cards)
    │   └── Manual/
    │       └── manual_*.md                  # Bedienungsanleitung-Slots
    ├── support/
    │   └── support.md
    ├── CNAME
    └── en/                                  # EN-Spiegelung der gesamten DE-Struktur
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

## Checkliste: Neues Produkt hinzufügen

- [ ] Ordner `docs/<PRODUKT>/` und `docs/<PRODUKT>/Manual/` anlegen (UPPERCASE, keine Leerzeichen)
- [ ] `docs/<PRODUKT>/index.md` mit Grid-Cards-Vorlage füllen (Produktbild-TODO einfügen)
- [ ] Manual-Slots befüllen (nur die zutreffenden — siehe Slot-Tabelle)
- [ ] Inhalte aus Original-Quelle (PDF) **wortgetreu** übernehmen — nichts erfinden, nichts auslassen
- [ ] Admonitions im richtigen Typ verwenden (Gefahr/Warnung/Vorsicht/Achtung/Hinweis)
- [ ] `<!-- TODO: Abbildung ... -->` für noch nicht vorhandene Bilder einfügen
- [ ] Spiegelstruktur unter `docs/en/<PRODUKT>/...` mit englischer Übersetzung erzeugen
- [ ] `mkdocs.yml` `nav: → Produkte:` neuen Block ergänzen
- [ ] `mkdocs.yml` `nav_translations:` für ggf. neue Section-Beschriftungen ergänzen
- [ ] `docs/index.md` Grid-Card-Eintrag hinzufügen
- [ ] `docs/en/index.md` Grid-Card-Eintrag hinzufügen
- [ ] Bilder unter `docs/assets/<produkt>/` ablegen, falls vorhanden
- [ ] Lokal `mkdocs build --strict` ausführen — keine Errors / Warnings akzeptieren
- [ ] Lokal `mkdocs serve` und im Browser stichprobenhaft prüfen (Sidebar, Cards, Verlinkungen, CE-Bilder)
- [ ] Commit auf passenden Feature-Branch, Push, ggf. PR

## Existierende Produkte (Stand: dieses Repo)

- `PANC/` — TEQSAS PAN-C
- `LAPTEQPLUS/` — LAP-TEQ PLUS (Display + INCLINOMETER)
- `LAPTEQPLUSATMOSPHERE/` — LAP-TEQ PLUS Atmosphere (Temperatur/Feuchte-Sensor)
- `LAPTEQPLUSELEVATION/` — LAP-TEQ PLUS Elevation (Lasersensor zur Höhenmessung)
- `INTERFACE/` — LAP-TEQ PLUS INTERFACE (mit zusätzlicher API-Doku unter `INTERFACE/API/`)
