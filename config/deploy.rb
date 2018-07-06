# config valid only for Capistrano 3.4
lock '3.4.1'

set :application, 'cadoles'
#set :repo_url, 'ssh://gogs@forge.cadoles.com:4242/cadolesdev/cadoles.git'
set :repo_url, 'https://github.com/cadoles/covoiturage-libre.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :branch, ENV['BRANCH'] if ENV['BRANCH']

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/opt/covoit-crous'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{
    config/database.yml
    config/secrets.yml
}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/ckeditor_assets}

set :passenger_restart_with_touch, true

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


def copy_config_file(file)
    local_file  = File.dirname(__FILE__) + "/#{file}"
    server_file = "#{ deploy_to }/shared/config/#{file}"
    upload! local_file, server_file#, :via => :scp, :mode => "755" 
    #execute :sudo, "rm -rf #{ latest_release }/config/#{file}"
    #execute :sudo, "ln -s #{ deploy_to }/shared/config/#{file} #{ latest_release }/config/#{file}"
end

namespace :deploy do

  desc "Deploy and symlink shared config files"
  task :config do
    on roles(:app) do
      execute "mkdir -p #{ deploy_to }/shared/config/initializers", :pty => true

      copy_config_file "database.yml"
      copy_config_file "secrets.yml"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "paperclip:refresh:missing_styles"
        end
      end
    end
  end


  before :deploy, 'deploy:config'
  after :deploy, "deploy:build_missing_paperclip_styles"
  after :publishing, :restart
  after :finishing, :cleanup

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
