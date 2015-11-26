set :user, 'hosting_maxopka'
set :login, 'hosting_maxopka'
set :use_sudo, false
set :application, "10001000"
set :deploy_to, "/home/#{fetch(:user)}/projects/#{fetch(:application)}"
set :shared_path, File.join(fetch(:deploy_to), 'shared')
set :unicorn_conf, "/etc/unicorn/#{fetch(:application)}.#{fetch(:login)}.rb"
set :unicorn_pid, "/var/run/unicorn/#{fetch(:user)}/#{fetch(:application)}.#{fetch(:login)}.pid"
set :bundle_dir, File.join(fetch(:shared_path), 'gems')
set :roles, %w{:web :app}
set :deploy_server, "sulfur.locum.ru"
set :bundle_without, [:development, :test]
set :rvm_ruby_string, "2.2.2"
set :rake, "rvm use #{fetch(:rvm_ruby_string)} do bundle exec rake"
set :bundle_cmd, "rvm use #{fetch(:rvm_ruby_string)} do bundle"
set :scm, :git
set :repo_url, 'git@github.com:MAXOPKA/10001000.git'

set :unicorn_start_cmd, "(cd #{fetch(:deploy_to)}/current; rvm use #{fetch(:rvm_ruby_string)} do bundle exec unicorn -Dc #{fetch(:unicorn_conf)})"
# - for unicorn - #
namespace :deploy do

  before 'deploy:updated', 'deploy:set_current_release'
  after 'deploy', 'unicorn:restart'

  task :set_current_release do
    on roles(:web) do
      abort 'sdff'
      set :current_release, latest_release
    end
  end

end

# fix ssh failures
class Net::SSH::Authentication::KeyManager
  def use_agent?
    false
  end
end
