# kibarai.tech

Sitio corporativo de Kibarai. Jekyll + GitHub Pages + PagesCMS.

## Puesta en marcha

### 1. Repositorio en GitHub

```bash
git init
git add .
git commit -m "chore: bootstrap kibarai.tech"
git branch -M main
git remote add origin git@github.com:<usuario-u-org>/kibarai-web.git
git push -u origin main
```

### 2. Activar GitHub Pages

En `Settings → Pages` del repo:
- **Source:** Deploy from a branch
- **Branch:** `main` / `/ (root)`

El dominio ya está configurado con el archivo `CNAME` (`kibarai.tech`). En tu DNS, apunta `kibarai.tech`:
- **A records** a `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`.
- **CNAME** `www` a `<usuario>.github.io`.

Marca "Enforce HTTPS" cuando GitHub emita el certificado.

### 3. Conectar PagesCMS

1. Ve a https://app.pagescms.org y autoriza el repo.
2. PagesCMS detectará el archivo `.pages.yml` automáticamente.
3. Edita contenido desde la interfaz web; cada guardado hace commit al repo y GitHub Pages redepliega.

## Estructura

```
├── _config.yml           # Config Jekyll
├── _data/site.yml        # Textos globales editables desde CMS
├── _layouts/             # default, page, post
├── _includes/            # header, footer
├── _services/            # Colección Servicios
├── _team/                # Colección Equipo
├── _posts/               # Blog
├── assets/               # css, img, uploads (CMS)
├── .pages.yml            # Config PagesCMS
├── index.html            # Home
├── servicios.html
├── nosotros.md
├── contacto.md
├── blog.html
└── CNAME
```

## Desarrollo local (opcional)

```bash
bundle install
bundle exec jekyll serve
```

Abre http://localhost:4000.

## Añadir idiomas

Cada archivo de contenido lleva un campo `lang: es`. Para añadir inglés:

1. Instala `jekyll-polyglot` (fuera de GH Pages nativo — requeriría GitHub Actions).
2. Duplica los archivos con `lang: en` y crea layouts con selector de idioma.

Mientras tanto, el modelo de datos ya soporta el campo `lang` desde el CMS.

## Roadmap corto

- Reemplazar logo y favicon en `assets/img/`.
- Añadir foto real del equipo en `_team/`.
- Cuando toque, descomentar el bloque `cases` en `.pages.yml` y crear `_cases/`.
