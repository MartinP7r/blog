source "https://rubygems.org"

gem "jekyll"
gem "jekyll-theme-chirpy", "~> 5.0", ">= 5.0.0"

group :jekyll_plugins do
  # gem "jekyll-twitter-plugin", "~> 2.1"
  gem 'jekyll-compose'
  gem 'jekyll-sitemap'
  # gem 'jekyll-assets'
  gem 'premonition'
end

group :test do
  gem "html-proofer", "~> 3.18"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?

# Jekyll <= 4.2.0 compatibility with Ruby 3.0
gem "webrick", "~> 1.7"
