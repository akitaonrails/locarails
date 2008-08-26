#!/usr/bin/env ruby -wKU
require 'yaml'
require 'erb'

operation, deploy_to = ARGV
cfg = YAML::load(ERB.new(IO.read("#{deploy_to}/etc/database.yml")).result)
exit 0 unless cfg['production'] # sai se nao encontrar o arquivo de banco
prd = cfg['production']
mysql_opts = "-u #{prd['username']} -p#{prd['password']} -h #{prd['host']} #{prd['database']}"
mysql_opts_no_data = "-u #{prd['username']} -p#{prd['password']} -h #{prd['host']} --add-drop-table --no-data #{prd['database']}"

commands = []

case operation
when 'backup'
  commands << "mysqldump #{mysql_opts} > #{deploy_to}/etc/dump.sql"
  commands << "cd #{deploy_to}/etc && tar cvfz dump.tar.gz dump.sql"
  commands << "rm #{deploy_to}/etc/dump.sql"
when 'restore'
  commands << "cd #{deploy_to}/etc && if [ -f dump.tar.gz ]; then tar xvfz dump.tar.gz dump.sql ; fi"
  commands << "if [ -f #{deploy_to}/etc/dump.sql ]; then mysql -u #{mysql_opts} < #{deploy_to}/etc/dump.sql && rm #{deploy_to}/etc/dump.sql ; fi"
when 'drop_all'
  commands << "mysqldump #{mysql_opts_no_data} | grep ^DROP | mysql #{mysql_opts}"
end

commands.each do |cmd|
  puts "executando: #{cmd.gsub(prd['password'], '*****')}"
  `#{cmd}`
end
puts "operacao #{operation} finalizada."  
