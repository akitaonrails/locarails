require "date"
require "fileutils"
require "rubygems"
require 'rubygems/gem_runner'
Gem.instance_eval do
  alias :old_manage_gems :manage_gems
  def manage_gems
    # do nothing - hide the warning message
  end
end
require "rake/gempackagetask"
require 'lib/locarails/version'

Dir['tasks/**/*.rake'].each { |rake| load rake }