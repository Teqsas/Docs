# Skeleton: neues Produkt anlegen

Dieser Ordner ist **nicht** Teil der gerenderten MkDocs-Seite — er ist eine
Kopiervorlage. So legst du ein neues Produkt an:

1. Kopiere diesen Ordner einmal nach `docs/<NEUER_PRODUKTNAME>/` (UPPERCASE,
   keine Leerzeichen / Bindestriche, z. B. `LAPTEQPLUSORBITAL`).
2. Kopiere ihn ein zweites Mal nach `docs/en/<NEUER_PRODUKTNAME>/` für die
   englische Spiegelung.
3. Trage in beiden `index.md` das **Frontmatter** aus:
   - `title:` — Pflicht, der Produktname auf dem PDF-Cover und in MkDocs.
   - `cover_image:` — optional, Pfad relativ zu `docs/`, z. B.
     `assets/<produktname>/hero.jpg`. Wird unter dem Logo aufs Cover gesetzt.
4. Befülle die `Manual/manual_*.md`-Slots gemäß
   [`AGENTS.md` → Manual-Slot-Konvention](../../AGENTS.md). Slots, die für
   dein Produkt nicht zutreffen, einfach löschen.
5. `mkdocs.yml` ergänzen (`nav: → Produkte:` neuer Block + ggf.
   `nav_translations:`).
6. Push → der `pdf`-Workflow entdeckt das neue Verzeichnis automatisch und
   produziert beim nächsten grünen Lauf
   `docs/assets/downloads/<NEUER_PRODUKTNAME>_DE.pdf` und `_EN.pdf`.

Der Validator (`pdf/validate_products.py`) prüft, dass `title` gesetzt ist
und die Pflicht-Slots vorhanden sind. Lokal ausführbar mit:

```sh
python3 pdf/validate_products.py
```
