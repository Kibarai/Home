# Kibarai

Corporate website for **Kibarai** (Kibarai Tech S.L.U.), a process-automation and
custom-software consultancy. Jekyll 4, deployed to GitHub Pages, content edited
through [PagesCMS](https://pagescms.org).

## How it works

Two ideas hold the whole site up.

**1. Pages are built from blocks.** Every page is a file in `_pages_i18n/<lang>/`
whose front matter carries a `blocks:` list. Each block names a type, and
`_layouts/blocks.html` renders it with the matching include from
`_includes/blocks/`. Adding a page means adding a file and choosing blocks — no
template work. That is what makes pages creatable from the CMS.

**2. Languages are discovered, not configured.** `_plugins/i18n.rb` reads the
files in `_data/i18n/` and whatever it finds there becomes the site's languages.
Navigation, URLs, footer, form labels and legal pages all live in those files.
Pages carry their own `permalink`, so each language's URLs are whatever its
pages say they are.

Adding a language is therefore: drop `_data/i18n/<lang>.yml` and create
`_pages_i18n/<lang>/`. No code changes.

## Structure

```
_config.yml              Jekyll config
_data/i18n/{es,en}.yml   Nav, URLs, footer, form labels, legal data and pages
_pages_i18n/{es,en}/     One file per page, each a list of blocks
_layouts/
  default.html           Shell: head, header, footer, cookie banner
  blocks.html            Walks page.blocks and includes each one
_includes/
  blocks/                One include per block type (14 of them)
  header.html footer.html cookie-banner.html hero-illustration.html icon.html
  diagnostic-form.html   Rendered only when contact.form_endpoint is set
_plugins/i18n.rb         Language discovery and per-language routing
assets/css/main.css      Design tokens at the top, block styles at the bottom
.pages.yml               PagesCMS schema — mirrors the data structures above
index.html               Root: redirects to the visitor's language
```

### Block types

`hero` · `dolor` · `cifras` · `soluciones` · `tarjetas` · `antes-despues` ·
`comparativa` · `proceso` · `fundador` · `garantias` · `faq` · `texto` ·
`legal` · `cta`

Unknown block types are skipped rather than erroring, so a page saved from the
CMS with a block this build does not know still renders the rest of itself.

## Editing content

Connect the repo to [app.pagescms.org](https://app.pagescms.org). It reads
`.pages.yml` and exposes three collections:

- **Páginas** — every page, with its block builder
- **Idiomas del sitio** — one file per language: nav, URLs, footer, form, legal
- **Blog (desactivado)** — wired up but empty; create a post to switch it back on

Every save is a commit on `main` and triggers a redeploy. If you change the
shape of the data, update `.pages.yml` in the same commit or the CMS stops being
able to edit that field.

## Local development

The system Ruby on macOS is too old. Use the Homebrew one, which is keg-only and
therefore not on `PATH` by default:

```bash
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
bundle install
bundle exec jekyll serve --livereload
```

Open <http://localhost:4000/>.

## Deployment

GitHub Actions (`.github/workflows/pages.yml`) builds on every push to `main`.
The site needs the Actions build rather than GitHub Pages' native Jekyll because
of the custom plugin in `_plugins/`.

Served at **<https://kibarai.tech>**.

## Design tokens

At the top of `assets/css/main.css`:

```css
--primary:    #2d3663;   /* navy — headings, footer, dark panels */
--secondary:  #6e92ff;   /* light blue — accents, eyebrows, rules */
--tertiary:   #00398f;   /* deep blue — links */
--bg-soft:    #f6f9ff;   /* alternating section background */
--bg-accent:  #e6eefa;   /* tags, numerals */
--serif-heading: "Poppins", …;
--sans:          "Inter", …;
```

## License

Content © Kibarai Tech S.L.U. Code released under the MIT License unless
otherwise noted.
