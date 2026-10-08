# Architecture

Teaching repository for an undergraduate "Introduction to Relational
Databases" course (Gianluca Della Vedova, Univ. of Milano–Bicocca).
It is a **content + tooling repo, not an application**: five lecture
slide decks authored in Markdown and compiled to Beamer PDFs (and
optionally reveal.js HTML) with pandoc, plus Northwind sample data
(SQLite + CSV) and MySQL classroom-provisioning scripts. No tests, no
README; one GitHub Actions workflow publishes the PDFs to GitHub Pages. Content is CC BY 4.0 (derived from Mark Jordan's
*Introduction to Relational Databases*); `scripts/` is public domain.

## Directory layout

- `0X-*.md` — lecture sources (pandoc Markdown; one slide per `##` heading):
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
    contrasted with an equivalent `WHERE` formulation.
  - `05-nested-queries.md` — `IN/NOT IN`, `EXISTS/NOT EXISTS`, correlated
    subqueries, "row with max" idioms. Reuses 04's examples.
- `0X-*.html` — generated reveal.js decks (only `01-intro.html` committed).
- `assets/` — images (ER diagrams, normalization examples, DB-tool
  screenshots), the intro lecture's `books.csv` / `books.sqlite` /
  `books.ods`, and `ClassSchedules.mwb`.
- `scripts/` — `createdbs.sh` (per-student MySQL DB/user provisioning),
  `Books.sql` / `ClassSchedules.sql` (MySQL 5.5 dumps of the two course
  schemas), `Books.mwb` / `ClassSchedules.mwb` (MySQL Workbench models).
- `docs/` — legacy Jekyll site (`_config.yml` → `jekyll-theme-minimal`);
  superseded by the Pages workflow below.
- `.github/workflows/pages.yml` — builds the decks and deploys them to
  GitHub Pages.
- `Northwind_*.sqlite`, `*.csv` — sample data (see below).
- `Makefile`, `dump_northwind.sh`, `.gitignore` (ignores `/*.pdf`).

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

- `make` → `all` → `pdf`: for each `*.md` except `ARCHITECTURE.md`,
  `pandoc -t beamer --from markdown+grid_tables -V theme:metropolis
  --listings -V aspectratio:169 -V themeoptions:titleformat=smallcaps
  --pdf-engine xelatex` → one Beamer PDF per deck. Decks build in
  parallel (`MAKEFLAGS += -j$(nproc)`).
- CI (`pages.yml`, on push to `master`): apt-installs pandoc, TeX Live
  (xetex) and the fonts, runs `make pdf`, copies `0*.pdf` plus a
  generated `index.html` into the Pages artifact, deploys.
- `make 0X.html` (rule exists, commented out of `all:`):
  `pandoc -t revealjs --standalone --self-contained -V theme=moon`.
- `dump_northwind.sh`: iterates `sqlite3 Northwind_large.sqlite
  ".tables"` and dumps each table to `<Table>.csv`.
- `scripts/createdbs.sh`: prompts, then creates N MySQL databases
  (`footestNN`) + users with random passwords, grants privileges, and
  loads a schema dump (`Books.sql` / `ClassSchedules.sql`).

## Data flow

- Authoring: `0X-*.md` → pandoc → PDF (beamer) / HTML (reveal.js).
- Sample data: `Northwind_large.sqlite` → `dump_northwind.sh` → CSVs;
  `createdbs.sh` → per-student MySQL DBs from the `scripts/*.sql` dumps.
- Lectures are **not** tied to the Northwind files: each deck redefines
  its own small in-slide dataset (Authors/Books/BooksAuthors/Editions)
  and shows each query's result inline as a plain-text table.

## Design decisions

- Markdown is the single source of truth; PDFs are generated artifacts
  and gitignored. HTML decks are optional (reveal.js not vendored).
- Fonts: Open Sans (text) and Noto Sans Mono (code), set per deck via
  `\setsansfont`/`\setmonofont`; code blocks use listings with
  `\ttfamily` on a light grey framed background.
- Self-contained lectures: no cross-references between decks; sequence
  is implied by the `01`–`05` numbering.
- PDF engine switched from xelatex to lualatex (2025-10-23, likely for
  the variable-font Ubuntu Mono), then back to xelatex (2026-10-08) for
  ~2× faster builds once the decks moved to static fonts.
- Attribution: CC BY 4.0 with dual credit to Mark Jordan (original)
  and Gianluca Della Vedova (modifications).

## Dependencies

- **pandoc** + **xelatex** (PDF engine), **metropolis** beamer theme,
  **listings** package, **Open Sans** + **Noto Sans Mono** fonts (via
  `header-includes`; Ubuntu packages `fonts-open-sans`, `fonts-noto-mono`).
- **reveal.js** — expected at `./reveal.js` for HTML builds (not present).
- **sqlite3** CLI — `dump_northwind.sh`; students query the bundled DBs.
- **MySQL** client + **MySQL Workbench** — `createdbs.sh`, `.mwb` models.
- **GitHub Actions / Pages** — `pages.yml` (Pages source must be set to
  "GitHub Actions").

## Entry points

- **Teacher (authoring)**: edit `0X-*.md`, run `make pdf`.
- **Teacher (classroom setup)**: `scripts/createdbs.sh`.
- **Students**: `sqlite3 Northwind_small.sqlite` (or `_large`), the CSV
  exports, and the `assets/books.sqlite` example.
- **Distribution**: GitHub Pages (built by CI), or reveal.js HTML.
