# Simple i18n router for Kibarai.
#
# Auto-discovers languages from _data/i18n/<lang>.yml (Jekyll already loads
# these into site.data['i18n'][lang]). Everything that is language-specific
# lives in a folder named after the language:
#
#   _pages_i18n/<lang>/<slug>.md   pages built from blocks (CMS-editable)
#   _services/<lang>/<slug>.md     services
#   _posts/<lang>/<date>-<slug>.md posts (kept wired up; no posts right now)
#
# Pages carry their own `permalink` in front matter, so adding a page from the
# CMS needs no code change. Services and posts get their permalink from the
# `urls` block of their language, so their URL shape stays consistent.
#
# ponytail: adding a new language = drop a new _data/i18n/<lang>.yml and a
# _pages_i18n/<lang>/ folder. This file, the config and the templates stay put.
module Jekyll
  module KibaraiI18n
    class Generator < Jekyll::Generator
      safe true
      priority :high

      LANG_FOLDER_RE = %r{\A_?[a-z0-9_]+/([^/]+)/}.freeze

      def generate(site)
        i18n_data = site.data['i18n'] || {}
        return if i18n_data.empty?

        langs = i18n_data.keys.sort
        site.config['languages'] = langs
        site.config['fallback_lang'] ||= 'en'

        tag_pages(site, langs)
        route_posts_by_lang(site, i18n_data, langs)
        route_services_by_lang(site, i18n_data, langs)
      end

      private

      # Pages already know their own permalink. All they need is their language,
      # which is the folder they sit in.
      def tag_pages(site, langs)
        collection = site.collections['pages_i18n']
        return unless collection

        collection.docs.each do |doc|
          lang = lang_of(doc)
          doc.data['lang'] = lang if lang && langs.include?(lang)
        end
      end

      def route_posts_by_lang(site, i18n_data, langs)
        site.posts.docs.each do |post|
          lang = lang_of(post)
          next unless lang && langs.include?(lang)

          post.data['lang'] = lang
          prefix = i18n_data.dig(lang, 'urls', 'news_prefix')
          next unless prefix

          slug = post.data['slug'] ||
                 File.basename(post.basename_without_ext).sub(/\A\d{4}-\d{2}-\d{2}-/, '')
          post.data['permalink'] = "#{prefix}/#{post.date.strftime('%Y/%m')}/#{slug}/"
        end
      end

      def route_services_by_lang(site, i18n_data, langs)
        collection = site.collections['services']
        return unless collection

        collection.docs.each do |svc|
          lang = lang_of(svc)
          next unless lang && langs.include?(lang)

          svc.data['lang'] = lang
          base = i18n_data.dig(lang, 'urls', 'services')
          next unless base

          svc.data['permalink'] = "#{base}#{File.basename(svc.basename_without_ext)}/"
        end
      end

      def lang_of(doc)
        match = doc.relative_path.match(LANG_FOLDER_RE)
        match && match[1]
      end
    end
  end
end
