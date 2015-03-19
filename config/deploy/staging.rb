set :stage, :staging
set :rails_env, "staging"
set :unicorn_rack_env, "staging"
set :migration_role, 'db'

role :app, %w{root@192.168.33.12}
role :web, %w{root@192.168.33.12}
role :db, %w{root@192.168.33.12}, :primary => true

#server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value
#server '192.168.33.12', user: 'root', roles: %w{app, db}
server '192.168.33.12', user: 'root', roles: %w{app, web, db}

set :ssh_options, {
     keys: [File.expand_path('/root/.ssh/id_rsa')],
     forward_agent: true,
     #auth_methods: %w(publickey)
     auth_methods: %w(password)
     password: 'vagrant'
}

