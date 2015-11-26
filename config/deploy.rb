set :user, 'hosting_maxopka'
set :login, 'hosting_maxopka'
set :use_sudo, false
set :application, "10001000"
set :deploy_to, "/home/#{fetch(:user)}/projects/#{fetch(:application)}"
set :unicorn_conf, "/etc/unicorn/#{fetch(:application)}.#{fetch(:login)}.rb"
set :unicorn_pid, "/var/run/unicorn/#{fetch(:user)}/#{fetch(:application)}.#{fetch(:login)}.pid"
#set :bundle_dir, File.join(fetch(:shared_path), 'gems')
#set :roles, %w{:web :app}
set :deploy_server, "sulfur.locum.ru"
set :bundle_without, [:development, :test]
set :rvm_ruby_string, "2.2.2"
set :rake, "rvm use #{fetch(:rvm_ruby_string)} do bundle exec rake"
set :bundle_cmd, "rvm use #{fetch(:rvm_ruby_string)} do bundle"
set :scm, :git
set :repo_url, 'git@github.com:MAXOPKA/10001000.git'

set :unicorn_start_cmd, "(cd #{fetch(:deploy_to)}/current; rvm use #{fetch(:rvm_ruby_string)} do bundle exec unicorn_rails -Dc #{fetch(:unicorn_conf)})"

# - for unicorn - #
namespace :deploy do
  desc "Start application"
  task :start do
    on roles(:web) do
      execute unicorn_start_cmd
    end
  end
  desc "Stop application"
  task :stop do
    on roles(:web) do
      run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
    end
  end

  before :updated, :set_current_release

  task :set_current_release do
    on roles(:web) do
      set :current_release, latest_release
    end
  end

  desc "Restart Application"
  task :restart do
    on roles(:web) do
      abort 'dfs'
      run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_start_cmd}"
    end
  end

  after 'deploy:publishing', 'deploy:restart'

end

# fix ssh failures
class Net::SSH::Authentication::KeyManager
  def use_agent?
    false
  end
end
