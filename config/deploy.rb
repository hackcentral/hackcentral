# config valid only for current version of Capistrano
lock '3.3.4'

set :application, 'hackcentral'
set :scm, :git
set :repo_url, 'git@github.com:me/hackcentral.git'
set :deploy_to, '/home/deploy/hackcentral'
set :rails_env, 'production'
set :rbenv_type, :user
set :rbenv_ruby, '2.1.3p242'

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
