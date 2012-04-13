require "bundler/capistrano"
load 'deploy/assets'

set :application, "submission_review2"
set :repository,  "git@github.com:scotlandonrails/submission_review2.git"
set :use_sudo, false
set :user, 'ubuntu'
ssh_options[:forward_agent] = true
set :deploy_to, "/home/#{user}/apps/#{application}"

default_run_options[:pty] = true

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

host="109.107.37.124"

role :web, host
role :app, host
role :db, host

default_environment["PATH"]         = "/home/ubuntu/.rvm/gems/ruby-1.9.3-p0/bin:/home/ubuntu/.rvm/gems/ruby-1.9.3-p0@global/bin:/home/ubuntu/.rvm/rubies/ruby-1.9.3-p0/bin:/home/ubuntu/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
default_environment["GEM_HOME"]     = "/home/ubuntu/.rvm/gems/ruby-1.9.3-p0"
default_environment["GEM_PATH"]     = "/home/ubuntu/.rvm/gems/ruby-1.9.3-p0:/home/ubuntu/.rvm/gems/ruby-1.9.3-p0@global"
default_environment["RUBY_VERSION"] = "1.9.3p0"

default_run_options[:shell] = 'bash'


set :rails_env, :production
set :unicorn_binary, "bundle exec unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.submission_review2.pid"


namespace :unicorn do
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    if remote_file_exists?(unicorn_pid)
      stop
    end
    start
  end
end

after 'deploy', 'unicorn:restart'

task :configlink do
  run "cd #{current_path}/config && rm database.yml && ln -s #{shared_path}/database.yml"
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end
