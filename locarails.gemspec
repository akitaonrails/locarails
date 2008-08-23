require 'lib/locarails/version.rb'
Gem::Specification.new do |s|
  s.name = %q{locarails}
  s.version = Locarails::VERSION::STRING

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Fabio Akita"]
  s.date = %q{2008-08-19}
  s.default_executable = %q{locarails}
  s.description = %q{A maneira mais simples para instalar aplicacoes Rails na hospedagem Linux da Locaweb.}
  s.email = %q{fabio.akita@locaweb.com.br}
  s.executables = ["locarails"]
  s.files = File.read("Manifest").split("\n")
  s.has_rdoc = true
  s.homepage = %q{http://www.locaweb.com.br/rails}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{locarails}
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Configuracao de Capistrano automatica para hospedagens Linux Locaweb.}
end
