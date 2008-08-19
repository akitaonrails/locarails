#!/usr/bin/env ruby -wKU
require 'yaml'

deploy_to    = ARGV[0]
cfg = YAML::load(File.open("#{deploy_to}/etc/database.yml"))
exit! unless cfg['production'] # sai se nao encontrar o arquivo de banco

cfg = cfg['production']
cmd_mysql    = "mysqldump -u #{cfg['username']} -p#{cfg['password']} -h #{cfg['host']} #{cfg['database']} > #{deploy_to}/etc/dump.sql"
cmd_compress = "cd #{deploy_to}/etc && tar cvfz dump.tar.gz dump.sql"
cmd_rm       = "rm #{deploy_to}/etc/dump.sql"

puts "executing: #{cmd_mysql.gsub(cfg['password'], 'xxxxxxxx')}"
`#{cmd_mysql}`
puts "executing: #{cmd_compress}"
`#{cmd_compress}`
puts "executing: #{cmd_rm}"
`#{cmd_rm}`
puts "db backup finished."