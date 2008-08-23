# =============================================================================
# TAREFAS - NAO MEXER A MENOS QUE SAIBA O QUE ESTA FAZENDO
# =============================================================================
desc "Garante que o database.yml foi corretamente configurado"
task :before_symlink do
  on_rollback {}
  run "test -d #{release_path}/tmp || mkdir -m 755 #{release_path}/tmp"
  run "test -d #{release_path}/db || mkdir -m 755 #{release_path}/db"
  run "cp #{deploy_to}/etc/database.yml #{release_path}/config/database.yml"
  run "cd #{release_path} && rake db:migrate RAILS_ENV=production"
end

desc "Garante que as configuracoes estao adequadas"
task :before_setup do
  ts = Time.now.strftime("%y%m%d%H%M%S")
  # git folder
  run "test -d #{git_repo} || mkdir -p -m 755 #{git_repo}"
  run "test -d #{git_repo}/.git || cd #{git_repo} && git init"
  git_config = File.join(File.dirname(__FILE__), "../.git/config")
  has_git = false
  if File.exists?(git_config) && File.read(git_config) !~ /locaweb/
    `git remote add locaweb #{repository}`
    `git push locaweb #{branch}`
    has_git = true
  end
  
  run "if [ -d #{deploy_to} ]; then mv #{deploy_to} #{deploy_to}-#{ts}.old ; fi"
  run "test -d #{deploy_to} || mkdir -m 755 #{deploy_to}"
  run "test -d #{deploy_to}/etc || mkdir -m 755 #{deploy_to}/etc"
  run "if [ -d #{site_path} ]; then mv #{site_path} #{site_path}-#{ts}.old ; fi"
  run "if [ -h #{site_path} ]; then mv #{site_path} #{site_path}-#{ts}.old ; fi"
  run "ln -s #{deploy_to}/current/public #{public_html}/#{application}"
  put File.read(File.dirname(__FILE__) + "/database.locaweb.yml"), "#{deploy_to}/etc/database.yml"

  # ssh keygen
  put File.read(File.dirname(__FILE__) + "/ssh_helper.rb"), "#{deploy_to}/etc/ssh_helper.rb"
  run "test -f .ssh/id_rsa || ruby #{deploy_to}/etc/ssh_helper.rb /home/#{user}/.ssh/id_rsa #{domain} #{user}"
  
  unless has_git
    3.times { puts "" }
    puts "==============================================================="
    puts "Rode os seguintes comandos depois de criar seu repositorio Git:"
    puts ""
    puts "  git remote add locaweb #{repository}"
    puts "  git push locaweb #{branch}"
    puts "==============================================================="
    3.times { puts "" }
  end
end

desc "Prepare the production database before migration"
task :before_cold do
end

namespace :deploy do
  desc "Pede restart ao servidor Passenger"
  task :restart, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
end

[:start, :stop].each do |t|
    desc "A tarefa #{t} nao eh necessaria num ambiente com Passenger"
    task t, :roles => :app do ; end
end

namespace :log do
  desc "tail production log files" 
  task :tail, :roles => :app do
    run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
      puts  # para uma linha extra 
      puts "#{channel[:host]}: #{data}" 
      break if stream == :err    
    end
  end
end

namespace :db do
  desc "Faz o backup remoto do banco de dados MySQL e ja faz o download"
  task :backup, :roles => :db do
    backup_rb ||= "#{deploy_to}/current/config/locaweb_backup.rb"
    run "if [ -f #{backup_rb} ]; then ruby #{backup_rb} #{deploy_to} ; fi"
    get "#{deploy_to}/etc/dump.tar.gz", "dump.tar.gz"
    run "rm #{deploy_to}/etc/dump.tar.gz"
  end
end
