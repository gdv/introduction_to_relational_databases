# Architecture

Teaching repository for an undergraduate "Introduction to Relational
Databases" course (Gianluca Della Vedova, Univ. of Milano–Bicocca).
It is a **content + tooling repo, not an application**: five lecture
slide decks authored as [Slidev](https://sli.dev) Markdown and built
into static web apps, plus Northwind sample data
(SQLite + CSV) and MySQL classroom-provisioning scripts. No tests, no
README; one GitHub Actions workflow publishes the decks to GitHub Pages. Content is CC BY 4.0 (derived from Mark Jordan's
*Introduction to Relational Databases*); `scripts/` is public domain.

## Directory layout

- `0X-*.md` — lecture sources, all **Slidev** decks (`theme: nord`,
  slides separated by `---`, per-slide frontmatter for layouts such as
  `two-cols`/`two-cols-header`, `v-click`/`v-clicks` reveals, code line
  highlighting, Shiki magic-move, KaTeX math, `> **Definition**`
  blockquotes; raw HTML/`<div>` avoided). Each ends by importing the
  shared license slide with `src: ./pages/license.md`:
  - `01-intro.md` — relational model: tables, one-cell-one-value, PKs/FKs,
    join tables, NULL semantics, data anomalies, functional dependencies,
    superkeys/keys, BCNF, normalization, CSV vs JSON.
  - `02-sql-single-table.md` — `SELECT/FROM/WHERE`, projection vs selection,
    `DISTINCT`, `LIKE`, `ORDER BY`, `COUNT/AVG/SUM/MIN/MAX`, `GROUP BY`/
    `HAVING`, execution order FROM→WHERE→GROUP BY→HAVING→SELECT.
  - `03-sql-more-tables.md` — foreign keys + referential-integrity options,
    comma-style vs `JOIN ... ON`, qualified names, aliases, join semantics
    (cross product → WHERE → projection), `LEFT JOIN`, `COUNT(*)` vs
    `COUNT(col)` in outer-join counting.
  - `04-set-operations.md` — `INTERSECT/UNION/UNION ALL/EXCEPT`, each
    contrasted with an equivalent `WHERE` formulation (magic-move).
  - `05-nested-queries.md` — `IN/NOT IN`, `EXISTS/NOT EXISTS`, correlated
    subqueries, "row with max" idioms. Reuses 04's examples.
- `pages/license.md` — shared CC BY 4.0 license slide.
- `assets/` — images (ER diagrams, normalization examples, DB-tool
  screenshots), the intro lecture's `books.csv` / `books.sqlite` /
  `books.ods`, and `ClassSchedules.mwb`.
- `scripts/` — `createdbs.sh` (per-student MySQL DB/user provisioning),
  `Books.sql` / `ClassSchedules.sql` (MySQL 5.5 dumps of the two course
  schemas), `Books.mwb` / `ClassSchedules.mwb` (MySQL Workbench models).
- `styles/index.css` — Slidev deck-wide CSS overrides on top of the nord
  theme (larger code blocks, smaller tables, no padding on `pre code`).
- `site/index.html` — GitHub Pages landing page listing the decks
  (hand-maintained: add a `<li>` linking `0X-name/` when adding a deck).
- `docs/` — legacy Jekyll site (`_config.yml` → `jekyll-theme-minimal`);
  superseded by the Pages workflow below.
- `.github/workflows/pages.yml` — builds the decks and deploys them to
  GitHub Pages.
- `Northwind_*.sqlite`, `*.csv` — sample data (see below).
- `Makefile`, `package.json` (Slidev CLI + nord theme), `dump_northwind.sh`,
  `.gitignore` (ignores `/*.pdf`, `node_modules/`, `/_site/`).

## Data assets

- `Northwind_large.sqlite` (30.7 MB) — classic Northwind schema
  (13 tables: Customers, Orders, OrderDetails, Products, Suppliers,
  Employees, Shippers, Categories, Region, Territories,
  EmployeeTerritories, CustomerDemographics, CustomerCustomerDemo),
  scaled up: 16,818 orders, 621,883 order_details, 91 customers,
  77 products. `ProductDetails_V` is a denormalized view.
- `Northwind_small.sqlite` (440 KB) — a *different* Northwind variant
  (21 tables incl. `inventory_transactions`, `purchase_orders`,
  `invoices`, `orders_status`): 48 orders, 58 order_details, 45 products.
- `*.csv` — per-table dumps of `Northwind_large.sqlite` produced by
  `dump_northwind.sh` (`sqlite3 -header -csv ... "select * from T"`).
  `OrderDetails.csv` is 16.9 MB; `CustomerDemographics.csv` and
  `CustomerCustomerDemo.csv` are empty (0 bytes).
- `assets/books.sqlite` + `assets/books.csv` — small Authors/Books
  example used in lecture 01.

## Control flow (build pipeline)

- `make` → `all` → `site`: copies `site/index.html` to `_site/` and, for
  each `0X-*.md`, runs `npx slidev build X.md --base ./ --router-mode
  hash --out _site/X` (needs `npm ci`). Relative base + hash routing
  make each deck work under any subpath (GitHub Pages project URL) and
  survive reloads on any slide. `make clean` removes `_site/`.
- `npm run dev -- 0X-name.md` serves a deck live. Slidev merges any
  `index.html` next to the entry file into every slide, which is why
  the landing page lives in `site/`.
- CI (`pages.yml`, on push to `master`): Node 22, `npm ci`, `make site`,
  uploads `_site/` as the Pages artifact, deploys.
- `dump_northwind.sh`: iterates `sqlite3 Northwind_large.sqlite
  ".tables"` and dumps each table to `<Table>.csv`.
- `scripts/createdbs.sh`: prompts, then creates N MySQL databases
  (`footestNN`) + users with random passwords, grants privileges, and
  loads a schema dump (`Books.sql` / `ClassSchedules.sql`).

## Data flow

- Authoring: `0X-*.md` → Slidev → static SPA in `_site/0X-name/`.
- Sample data: `Northwind_large.sqlite` → `dump_northwind.sh` → CSVs;
  `createdbs.sh` → per-student MySQL DBs from the `scripts/*.sql` dumps.
- Lectures are **not** tied to the Northwind files: each deck redefines
  its own small in-slide dataset (Authors/Books/BooksAuthors/Editions)
  and shows each query's result inline as a Markdown table.

## Design decisions

- Markdown is the single source of truth; built decks are generated
  and gitignored. Only the web decks are published (no PDFs).
- Look: nord theme plus `styles/index.css` overrides; prefer Slidev
  layouts/directives over inline HTML.
- Self-contained lectures: no cross-references between decks; sequence
  is implied by the `01`–`05` numbering.
- Decks migrated from pandoc/Beamer PDFs to Slidev web decks
  (2026-10-14).
- Attribution: CC BY 4.0 with dual credit to Mark Jordan (original)
  and Gianluca Della Vedova (modifications).

## Dependencies

- **Node.js** + **@slidev/cli** + **slidev-theme-nord** (`package.json`).
- **sqlite3** CLI — `dump_northwind.sh`; students query the bundled DBs.
- **MySQL** client + **MySQL Workbench** — `createdbs.sh`, `.mwb` models.
- **GitHub Actions / Pages** — `pages.yml` (Pages source must be set to
  "GitHub Actions").

## Entry points

- **Teacher (authoring)**: edit `0X-*.md`, preview with
  `npm run dev -- 0X-name.md`, build with `make`.
- **Teacher (classroom setup)**: `scripts/createdbs.sh`.
- **Students**: `sqlite3 Northwind_small.sqlite` (or `_large`), the CSV
  exports, and the `assets/books.sqlite` example.
- **Distribution**: GitHub Pages (built by CI).
