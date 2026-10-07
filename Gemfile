source "https://rubygems.org"

# Pins Jekyll and plugins to exactly what GitHub Pages builds with.
# Update with: bundle update github-pages
gem "github-pages", group: :jekyll_plugins

# Needed for `jekyll serve` on Ruby 3+.
gem "webrick"

# Windows has no zoneinfo files.
platforms :mingw, :x64_mingw, :mswin do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end
