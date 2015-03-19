# coding: utf-8
# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'first_app'
set :repo_url, 'git@github.com:ITBOSS/first_app.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/vagrant/workspace/first_app'

# Default value for :scm is :git
set :scm, :git

set :format, :pretty
set :log_level, :debug

set :pty, true

# Default value for keep_releases is 5
set :keep_releases, 5

#set :rbenv_type, :system # :system or :user
set :rbenv_type, :user # :system or :user
set :rbenv_ruby, '2.1.4'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle}
#set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
#set :bundle_jobs, 4

# SSHKit.conifg
#SSHKit.config.command_map[:rake] = 'bundle exec rake'

namespace :deploy do

  desc 'Upload database.yml'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/database.yml', "#{shared_path}/config/database.yml")
    end
  end

#  desc 'db_seed must be run only one time right after the first deploy'
#  task :db_seed do
#    on roles(:db) do |host|
#      within current_path do
#        with rails_env: fetch(:rails_env) do
#          execute :rake, 'db:seed'
#        end
#      end
#    end
#  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      invoke 'unicorn:restart'
    end
  end
end


before 'deploy:starting', 'deploy:upload'
# Capistrano 3.1.0 からデフォルトで deploy:restart タスクが呼ばれなくなったので、ここに以下の1行を書く必要がある
after 'deploy:publishing', 'deploy:restart'
