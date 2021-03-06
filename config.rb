set :css_dir,    'assets/stylesheets'
set :js_dir,     'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir,  'assets/fonts'
set :layouts_dir,  'templates/layouts'
set :partials_dir, 'templates/partials'

page 'trivia/*', layout: :trivia

compass_config do |config|
  config.output_style = :nested
  # Temporarily disabling warnings to suppress "interpolation near operators"
  # noise from _deprecated-support.scss. Recheck when Compass is upgraded.
  config.disable_warnings = true
end

helpers do
  def strip_byte_order_mark(str)
    str.sub("\xEF\xBB\xBF".force_encoding('UTF-8'), '')
  end

  def inline_stylesheet(name)
    strip_byte_order_mark(
      sprockets["#{name}.css"].to_s.strip
    )
  end

  def inline_javascript(name)
    sprockets["#{name}.js"].to_s.strip
  end

  def abovefold_styles(page_classes)
    styles = []
    styles << inline_stylesheet('_abovefold')
    page_classes.split.each do |page|
      styles << inline_stylesheet("_abovefold_#{page}")
    end
    styles.compact.join('')
  end
end

configure :build do

  # Monkeypatch middleman-core/lib/middleman-core/sitemap.rb to allow Netlify's
  # magic files to be copied into the build directory.
  unless ENV['IGNORE_BITBALLOON']
    bitballoon_configs = %w(_headers _redirects)
    config[:ignored_sitemap_matchers][:partials] = proc do |file|
      basename = File.basename(file)
      basename.start_with?('_') && !bitballoon_configs.include?(basename)
    end
  end

  compass_config do |config|
    config.output_style = :compressed
    config.line_comments = false
  end

  helpers do
    def inline_javascript(name)
      require 'uglifier'
      Uglifier.compile(
        sprockets["#{name}.js"].to_s.strip,
        output: { comments: :none }
      )
    end
  end

  ignore 'templates/layouts/*'
  ignore 'templates/partials/*'

  set :haml, ugly: true

  activate :minify_css
  activate :minify_javascript do |config|
    config.inline = true
  end
  activate :asset_hash
  activate :gzip

  # Only use asset host if environment variable is set (see Rakefile task).
  # Since this CloudFront distribution is pointed to Eris, we don't want to
  # use it when Netlify runs a plain vanilla "middleman build".
  if ENV['CLOUDFRONT']
    activate :asset_host
    set :asset_host, 'https://d1msbq6ewzmie1.cloudfront.net'
  end

  activate :minify_html do |html|
    html.remove_input_attributes = false
    html.remove_intertag_spaces = false
  end
end

activate :deploy do |deploy|
  deploy.method = :rsync
  deploy.flags = %w(
    --checksum
    --compress
    --delay-updates
    --delete
    --delete-after
    --perms
    --recursive
    --verbose
  ).join(' ')
  deploy.build_before = true
  deploy.user = 'jack'
  deploy.host = 'eris.discordians.net'
  deploy.port = 22
  deploy.path = '/web/jlet.org/public_html'
end
