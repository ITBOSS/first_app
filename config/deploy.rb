# coding: utf-8
# config valid only for Capistrano 3.1
lock '3.2.1'

# アプリケーション名
set :application, 'first_app'
# githubのurl。プロジェクトのgitホスティング先を指定する
set :repo_url, 'git@github.com:ITBOSS/first_app.git'

# Default branch is :master
# deploy時にブランチを選択したい場合は、以下のコメント部分を外す
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# デプロイ先のサーバーのディレクトリ。フルパスで指定
set :deploy_to, '/vagrant/workspace/first_app'
# Version管理はgit
set :scm, :git

# ログを詳しく表示
set :format, :pretty
set :log_level, :debug

# sudo に必要
set :pty, true

# 何世代前までリリースを残しておくか
set :keep_releases, 5

#rbenvをシステムにインストールした or ユーザーローカルにインストールした
set :rbenv_type, :user # :system or :user
# rubyのversion
set :rbenv_ruby, '2.1.4'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :linked_files, %w{config/database.yml}
# デプロイ先のサーバーの :deploy_to/shared/config/database.yml のシンボリックリンクを
# :deploy_to/current/config/database.yml にはる。
# 先にshared以下にファイルをアップロードする必要あり
# 説明下記に

set :linked_dirs, %w{bin log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle}
# 同じくsharedに上記のディレクトリを生成し、currentにシンボリックリンクを張る

# bundle installの並列実行数
set :bundle_jobs, 4


namespace :deploy do

  # 上記linked_filesで使用するファイルをアップロードするタスク
  desc 'Upload database.yml'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/database.yml', "#{shared_path}/config/database.yml")
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      invoke 'unicorn:restart'
    end
  end
end

# # linked_filesで使用するファイルをアップロードするタスクは、deployが行われる前に実行する必要がある
before 'deploy:starting', 'deploy:upload'
# Capistrano 3.1.0 からデフォルトで deploy:restart タスクが呼ばれなくなったので、ここに以下の1行を書く必要がある
after 'deploy:publishing', 'deploy:restart'
