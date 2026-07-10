# Simple i18n generator for Kibarai.
#
# Auto-discovers languages from _data/i18n/<lang>.yml (Jekyll already loads
# these into site.data['i18n'][lang]). For each template in the _pages_i18n
# collection with a translation_key, this generator emits one output page per
# discovered language at the URL defined in that lang's `urls` block. Also
# routes posts under _posts/<lang>/ to per-lang permalinks read from the same
# `urls` block (news_prefix).
#
# ponytail: adding a new language = drop a new _data/i18n/<lang>.yml. Nothing
# else needs editing — this file, config, templates and CMS remain untouched.
module Jekyll
  module KibaraiI18n
    class Generator < Jekyll::Generator
      safe true
      priority :high

      POSTS_LANG_RE = %r{\A_posts/([^/]+)/}.freeze

      def generate(site)
        i18n_data = site.data['i18n'] || {}
        return if i18n_data.empty?

        langs = i18n_data.keys.sort
        site.config['languages'] = langs
        site.config['fallback_lang'] ||= 'en'

        emit_translated_pages(site, i18n_data, langs)
        route_posts_by_lang(site, i18n_data, langs)
        route_services_by_lang(site, i18n_data, langs)
      end

      private

      def emit_translated_pages(site, i18n_data, langs)
        collection = site.collections['pages_i18n']
        return unless collection

        collection.docs.each do |tpl|
          key = tpl.data['translation_key']
          next unless key

          langs.each do |lang|
            url = i18n_data.dig(lang, 'urls', key)
            next unless url

            page = Jekyll::PageWithoutAFile.new(site, site.source, '', "#{key}-#{lang}.html")
            page.content = tpl.content
            page.data = tpl.data.merge(
              'lang' => lang,
              'permalink' => url,
              'translation_key' => nil
            )
            site.pages << page
          end
        end
      end

      def route_posts_by_lang(site, i18n_data, langs)
        site.posts.docs.each do |post|
          match = post.relative_path.match(POSTS_LANG_RE)
          next unless match
          lang = match[1]
          next unless langs.include?(lang)

          post.data['lang'] = lang
          prefix = i18n_data.dig(lang, 'urls', 'news_prefix')
          next unless prefix

          slug = post.data['slug'] || File.basename(post.basename_without_ext).sub(/\A\d{4}-\d{2}-\d{2}-/, '')
          post.data['permalink'] = "#{prefix}/#{post.date.strftime('%Y/%m')}/#{slug}/"
        end
      end

      def route_services_by_lang(site, i18n_data, langs)
        collection = site.collections['services']
        return unless collection

        collection.docs.each do |svc|
          match = svc.relative_path.match(%r{\A_services/([^/]+)/})
          next unless match
          lang = match[1]
          next unless langs.include?(lang)

          svc.data['lang'] = lang
          base = i18n_data.dig(lang, 'urls', 'services')
          next unless base

          slug = File.basename(svc.basename_without_ext)
          svc.data['permalink'] = "#{base}#{slug}/"
        end
      end
    end
  end
end
