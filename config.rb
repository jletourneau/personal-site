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

configure :build do
  ignore 'templates/layouts/*'
  ignore 'templates/partials/*'

  set :haml, ugly: true

  activate :minify_css
  activate :minify_javascript
  activate :asset_hash

  activate :minify_html do |html|
    html.remove_input_attributes = false
  end
end
