desc 'Deploy site to Eris with CloudFront asset hosting.'
task :deploy do
  puts 'Deploying site to Eris with CloudFront asset hosting...'
  system(
    {
      'IGNORE_UNDERSCORE_FILES' => '1',
      'CLOUDFRONT' => '1',
    },
    'bundle exec middleman deploy'
  )
end
