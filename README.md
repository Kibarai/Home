# Kibarai

Corporate website for **Kibarai**, a technology consultancy. Built with Jekyll, deployed via GitHub Pages, and content-editable through PagesCMS.

Design inspired by the [CloudCannon Dante](https://github.com/CloudCannon/dante-jekyll-bookshop-template) template: navy + light-blue palette, Inter + Poppins typography, editorial home structure (hero + service cards + 3-step process + featured blog + CTA banner).

## Stack

- **Static site**: Jekyll 4
- **Fonts**: Inter (body) + Poppins (headings) from Google Fonts
- **Hosting**: GitHub Pages
- **CMS**: [PagesCMS](https://pagescms.org) — all visible copy lives in `_data/site.yml` and is editable from the browser
- **Plugins**: `jekyll-feed`, `jekyll-seo-tag`, `jekyll-sitemap`

## Structure

```
├── _config.yml           # Jekyll config
├── _data/site.yml        # All editable copy (nav, hero, sections, footer, legal…)
├── _layouts/             # default, page, post
├── _includes/            # header, footer, icon SVGs, hero illustration
├── _services/            # Services collection
├── _posts/               # Blog posts
├── assets/
│   ├── css/main.css      # Full stylesheet (design tokens as CSS custom properties)
│   ├── img/              # logo.svg, logo-dark.svg, favicon.svg
│   └── uploads/          # PagesCMS media
├── .pages.yml            # PagesCMS field schema
├── index.html            # Home
├── servicios.html        # Services
├── nosotros.html         # About
├── contacto.html         # Contact
├── blog.html             # Blog index
├── aviso-legal.html      # Legal notice
├── privacidad.html       # Privacy policy
└── cookies.html          # Cookie policy
```

## Editing content

Connect the repo to [app.pagescms.org](https://app.pagescms.org). PagesCMS reads `.pages.yml` and exposes an admin UI for:

- **Site settings** (`_data/site.yml`): brand, nav, hero, section headings, process steps, CTA, per-page copy, footer columns, legal data
- **Services** (`_services/`)
- **Blog posts** (`_posts/`)

Every save is a commit on `main` and triggers a redeploy.

Legal pages (`aviso-legal.html`, `privacidad.html`, `cookies.html`) render dynamically from `site.data.site.legal`. Fill in the legal block from the CMS and the three pages update at once.

## Local development

Requires Ruby 3.x and Bundler.

```bash
bundle install
bundle exec jekyll serve --future
```

Open <http://localhost:4000/home/>.

The `--future` flag is needed while any post has a date in the future.

## Deployment

GitHub Pages is configured to deploy from `main` / root. Any push (or PagesCMS save) triggers a rebuild.

Currently served at **<https://kibarai.github.io/home/>**.

To switch to the custom domain `kibarai.tech` later:

1. Add a `CNAME` file at the repo root containing `kibarai.tech`
2. In `_config.yml` set `url: https://kibarai.tech` and remove `baseurl`
3. Point `kibarai.tech` DNS to GitHub Pages (four `A` records + `CNAME www → kibarai.github.io`)
4. In GitHub → Settings → Pages, enter the custom domain and enable "Enforce HTTPS"

## Design tokens

Colors and typography live as CSS custom properties at the top of `assets/css/main.css`:

```css
--primary:    #2d3663;   /* navy — headings, footer bg */
--secondary:  #6e92ff;   /* light blue — accents, links on hover */
--tertiary:   #00398f;   /* deep blue — link color */
--bg-accent:  #e6eefa;   /* very light blue — soft backgrounds */
--serif-heading: "Poppins", …;
--sans:          "Inter", …;
```

## License

Content © Kibarai. Code released under the MIT License unless otherwise noted.
