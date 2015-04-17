set :css_dir,    'assets/stylesheets'
set :js_dir,     'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir,  'assets/fonts'

after_configuration do
  @bower_config = JSON.parse(IO.read(File.join(root, '.bowerrc')))
  sprockets.append_path(File.join(root, @bower_config['directory']))
end

set :layouts_dir,  'templates/layouts'
set :partials_dir, 'templates/partials'

compass_config do |config|
  config.output_style = :nested
end

helpers do
  def inline_stylesheet(name)
    content_tag :style do
      sprockets["#{name}.css"].to_s.strip
        .gsub("\xEF\xBB\xBF".force_encoding('UTF-8'), '')
    end
  end

  def inline_javascript(name)
    content_tag :script do
      sprockets["#{name}.js"].to_s.strip
    end
  end
end

configure :build do

  # Monkeypatch middleman-core/lib/middleman-core/sitemap.rb to allow Netlify's
  # magic files to be copied into the build directory.
  config[:ignored_sitemap_matchers][:partials] = proc do |file|
    file =~ %r{/_[^_]} && file !~ %r{/_(headers|redirects)}
  end

  compass_config do |config|
    config.output_style = :compressed
    config.line_comments = false
  end

  helpers do
    def inline_javascript(name)
      require 'uglifier'
      content_tag :script do
        Uglifier.compile(
          sprockets["#{name}.js"].to_s.strip
        )
      end
    end
  end

  ignore 'templates/layouts/*'
  ignore 'templates/partials/*'

  set :haml, ugly: true

  activate :minify_css
  activate :minify_javascript
  activate :asset_hash

  activate :minify_html do |html|
    html.remove_input_attributes = false
    html.remove_intertag_spaces = true
  end
end
