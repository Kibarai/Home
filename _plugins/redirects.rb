# Redirecciones de direcciones antiguas, leídas de _data/redirects.yml.
#
# GitHub Pages no deja configurar redirecciones 301 en el servidor. Lo
# siguiente mejor es una página en la dirección antigua con meta refresh a 0
# y canonical a la nueva: Google lo trata como una redirección permanente y
# pasa lo ganado a la nueva URL.
module Jekyll
  class RedirectPage < PageWithoutAFile
    def initialize(site, from, to)
      super(site, site.source, from, "index.html")
      destino = to.start_with?("http") ? to : "#{site.config['url']}#{site.config['baseurl']}#{to}"
      self.data = { "layout" => nil, "sitemap" => false }
      self.content = <<~HTML
        <!doctype html>
        <html>
        <head>
        <meta charset="utf-8">
        <title>Redirigiendo…</title>
        <link rel="canonical" href="#{destino}">
        <meta http-equiv="refresh" content="0; url=#{destino}">
        <meta name="robots" content="noindex">
        </head>
        <body><a href="#{destino}">#{destino}</a></body>
        </html>
      HTML
    end
  end

  class RedirectGenerator < Generator
    safe true
    priority :lowest

    def generate(site)
      existentes = (site.pages + site.documents).map(&:url)
      (site.data["redirects"] || {}).each do |from, to|
        if existentes.include?(from)
          Jekyll.logger.warn "Redirects:", "#{from} existe como página, no se redirige"
          next
        end
        site.pages << RedirectPage.new(site, from, to)
      end
    end
  end
end
