source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!

gem "github-pages", group: :jekyll_plugins

gem "wdm", "~> 0.1.0" if Gem.win_platform?

# ---------------------------------------------------------------------------
# 本地预览专用依赖：只在设置了 LOCAL_DEV=1 时安装（见 local/env.sh）。
#
# 这些包 GitHub Pages 用不到：
#   hawkins  —— jekyll serve 的 LiveReload，GitHub 上有同名 *插件*，曾导致线上构建失败
#   webrick  —— Ruby 3 下本地跑 serve 需要，线上不跑服务器
#
# 这样线上的 Gemfile 保持干净，与 GitHub Pages 的构建环境一致。
# ---------------------------------------------------------------------------
if ENV["LOCAL_DEV"] == "1"
  gem "hawkins"
  gem "webrick", "~> 1.8"
end

# If you have any plugins, put them here!
group :jekyll_plugins do
  # gem "jekyll-archives"
  gem "jekyll-feed"
  gem 'jekyll-sitemap'
end
