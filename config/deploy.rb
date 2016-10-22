# config/deploy.rb
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :domain,      '104.131.126.117'
set :user,        'deployer'
set :deploy_to,   '/home/deployer/blog'
set :repository,  'https://github.com/davidstump/davidstump.net.git'
set :branch,      'master'

task :environment do
  invoke :'rbenv:load'
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'
    queue "#{bundle_prefix} jekyll build"
  end
end
