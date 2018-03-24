source 'https://rubygems.org'

# Haml 5.* throws warnings: https://github.com/rtomayko/tilt/issues/316
# Resolved in Middleman 4.3.0, but punt on Haml upgrade until the Middleman 4
# to 5 breaking changes can be integrated.
gem 'haml', '~> 4.0'

gem 'middleman', '~> 3.0'
gem 'middleman-minify-html', '~> 3.0'
gem 'middleman-deploy', '~> 1.0'

# Requires "listen < 3.0, >= 1.0" which conflicts with Middleman 3.4.0. We only
# actually need this to compile the icon font when there are changes; i.e. it's
# not a runtime dependency. So the smart move seems to be to comment it out.
#
# gem 'fontcustom', '~> 1.3.0'
