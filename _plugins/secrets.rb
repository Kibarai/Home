# Valores que no deben estar en el repositorio (es público).
#
# En GitHub Actions llegan como secretos del repositorio (Settings > Secrets
# and variables > Actions), que .github/workflows/pages.yml pasa al build
# como variables de entorno. En local se leen de _secrets.yml, que está en
# .gitignore (copia _secrets.example.yml).
#
#   ACUMBAMAIL_CALCULADORA_FORM  action del formulario de Acumbamail de la
#                                calculadora. Acaba en el HTML publicado (el
#                                navegador envía ahí los datos), pero no en git.
#   KIBARAI_ACCESO               clave del enlace de vuelta tras confirmar
#                                (/confirmado/?acceso=...). En la web solo se
#                                publica su SHA-256, nunca la clave.
#
# Quedan en site.data.secrets: calculadora_form y acceso_sha256.
require "digest"
require "yaml"

module KibaraiSecrets
  KEYS = %w[ACUMBAMAIL_CALCULADORA_FORM KIBARAI_ACCESO].freeze

  def self.load(site)
    file = File.join(site.source, "_secrets.yml")
    local = File.exist?(file) ? (YAML.safe_load(File.read(file)) || {}) : {}
    values = KEYS.to_h { |k| [k, (ENV[k].to_s.strip.empty? ? local[k] : ENV[k]).to_s.strip] }

    missing = values.select { |_, v| v.empty? }.keys
    unless missing.empty?
      msg = "Faltan secretos: #{missing.join(', ')}. La calculadora no funcionará."
      raise msg if ENV["JEKYLL_ENV"] == "production"
      Jekyll.logger.warn "Secrets:", msg
    end

    acceso = values["KIBARAI_ACCESO"]
    {
      "calculadora_form" => values["ACUMBAMAIL_CALCULADORA_FORM"],
      "acceso_sha256" => acceso.empty? ? "" : Digest::SHA256.hexdigest(acceso),
    }
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  site.data["secrets"] = KibaraiSecrets.load(site)
end
