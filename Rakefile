desc 'Remove build directory completely.'
task :clean do
  rm_rf 'build'
end

desc 'Deploy site to Eris with CloudFront asset hosting.'
task :deploy do
  puts 'Deploying site to Eris with CloudFront asset hosting...'
  system(
    {
      'IGNORE_BITBALLOON' => '1',
      'CLOUDFRONT' => '1',
    },
    'bundle exec middleman deploy'
  )
end
