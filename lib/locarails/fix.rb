require 'rubygems'
unless Gem.source_index.find_name('capistrano').select { |g| g.version.to_s =~ /^2\.5/ }.empty?
  puts "Loading temporary fixes for Capistrano 2.5.x"
  require 'capistrano'
  require 'capistrano/recipes/deploy/dependencies'
  require 'capistrano/recipes/deploy/strategy/base'
  require 'capistrano/recipes/deploy/strategy/copy'
  require 'capistrano/recipes/deploy/scm/none'
  require 'locarails/base'
  require 'locarails/copy'
  require 'locarails/none'
end