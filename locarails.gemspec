Gem::Specification.new do |s|
  s.name = %q{locarails}
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Fabio Akita"]
  s.date = %q{2008-08-19}
  s.default_executable = %q{locarails}
  s.description = %q{A maneira mais simples para instalar aplicacoes Rails na hospedagem Linux da Locaweb.}
  s.email = %q{fabio.akita@locaweb.com.br}
  s.executables = ["locarails"]
  s.files = ["bin/locarails", "bin/locarails.cmd", "LICENSE", "Manifest", "README", "locarails.gemspec", "lib/locarails.rb", "lib/locarails/version.rb", "templates/database.locaweb.yml.erb", "templates/deploy.rb.erb", "templates/deploy.common.rb.erb", "templates/locaweb_backup.rb", "templates/ssh_helper.rb", "templates/.gitignore"]
  s.has_rdoc = true
  s.homepage = %q{http://www.locaweb.com.br/rails}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{locarails}
  s.rubygems_version = [s.version]
  s.summary = %q{Configuracao de Capistrano automatica para hospedagens Linux Locaweb.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<capistrano>, [">= 2.0.0"])
      s.add_runtime_dependency(%q<highline>, [">= 0"])
    else
      s.add_dependency(%q<capistrano>, [">= 2.0.0"])
      s.add_dependency(%q<highline>, [">= 0"])
    end
  else
    s.add_dependency(%q<capistrano>, [">= 2.0.0"])
    s.add_dependency(%q<highline>, [">= 0"])
  end

end
