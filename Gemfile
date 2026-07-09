source "https://rubygems.org"

gem "jekyll", "~> 4.3"
gem "webrick", "~> 1.8"

# Ruby 3.4 movió estos gems fuera de stdlib; hay que declararlos
gem "erb"
gem "csv"
gem "base64"
gem "bigdecimal"
gem "logger"
gem "ostruct"

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
end

# ponytail: dev local. GH Pages compila con su propio Ruby+github-pages gem,
# esto solo afecta a `jekyll serve` en tu máquina.
