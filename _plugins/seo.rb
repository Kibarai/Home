# Ajustes sobre lo que genera jekyll-seo-tag.
#
# Las páginas de _pages_i18n son documentos de colección y Jekyll les pone
# siempre fecha: si no tienen, la de la compilación. jekyll-seo-tag ve esa
# fecha y las marca como artículo (og:type article) publicado hoy, en cada
# despliegue. Para una web de servicios eso es falso: son páginas fijas.
#
# ponytail: si algún día hay blog, los posts no pasan por aquí y siguen siendo
# artículos con su fecha real.
Jekyll::Hooks.register :pages_i18n, :post_render do |doc|
  next unless doc.output_ext == ".html"

  html = doc.output
  html = html.sub('<meta property="og:type" content="article" />',
                  '<meta property="og:type" content="website" />')
  html = html.gsub(%r{<meta property="article:(published|modified)_time" content="[^"]*" />\n?}, "")
  html = html.gsub(/"date(Published|Modified)":"[^"]*",/, "")
  doc.output = html
end
