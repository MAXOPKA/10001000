namespace :unicorn do

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

  desc "Restart Application"
  task :restart do
    on roles(:web) do
      run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_start_cmd}"
    end
  end


end
