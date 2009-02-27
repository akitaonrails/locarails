# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{locarails}
  s.version = "1.1.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Fabio Akita"]
  s.date = %q{2008-12-24}
  s.default_executable = %q{locarails}
  s.description = %q{A maneira mais simples para instalar aplicacoes Rails na hospedagem Linux da Locaweb.}
  s.email = %q{fabio.akita@locaweb.com.br}
  s.executables = ["locarails"]
  s.files = ["bin/locarails", "bin/locarails.cmd", "lib/locarails", "lib/locarails/copy.rb", "lib/locarails/fix.rb", "lib/locarails/none.rb", "lib/locarails/version.rb", "lib/locarails.rb", "templates/database.locaweb.yml.erb", "templates/deploy.common.rb.erb", "templates/deploy.rb.erb", "templates/locaweb_backup.rb", "templates/ssh_helper.rb", "tasks/gems.rake", "templates/.gitignore"]
  s.has_rdoc = true
  s.homepage = %q{http://www.locaweb.com.br/rails}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Configuracao de Capistrano automatica para hospedagens Linux Locaweb.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, [">= 2.5.0"])
      s.add_runtime_dependency(%q<highline>, [">= 0"])
      s.add_runtime_dependency(%q<archive-tar-minitar>, [">= 0.5.2"])
    else
      s.add_dependency(%q<capistrano>, [">= 2.5.0"])
      s.add_dependency(%q<highline>, [">= 0"])
      s.add_dependency(%q<archive-tar-minitar>, [">= 0.5.2"])
    end
  else
    s.add_dependency(%q<capistrano>, [">= 2.5.0"])
    s.add_dependency(%q<highline>, [">= 0"])
    s.add_dependency(%q<archive-tar-minitar>, [">= 0.5.2"])
  end
end
