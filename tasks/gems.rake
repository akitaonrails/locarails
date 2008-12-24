locarails_gemspec = Gem::Specification.new do |s|
  s.name = %q{locarails}
  s.version = Locarails::VERSION::STRING

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Fabio Akita"]
  s.date = %q{Time.now.strftime("%Y/%d/%m")}
  s.default_executable = %q{locarails}
  s.description = %q{A maneira mais simples para instalar aplicacoes Rails na hospedagem Linux da Locaweb.}
  s.email = %q{fabio.akita@locaweb.com.br}
  s.executables = ["locarails"]
  s.files = Dir.glob("{bin,lib,templates,tasks}/**/*") + ['templates/.gitignore']
  s.has_rdoc = true
  s.homepage = %q{http://www.locaweb.com.br/rails}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{locarails}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Configuracao de Capistrano automatica para hospedagens Linux Locaweb.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end

  s.add_runtime_dependency(%q<capistrano>, [">= 2.0.0"])
  s.add_runtime_dependency(%q<highline>, [">= 0"])
  s.add_runtime_dependency(%q<archive-tar-minitar>, [">= 0.5.2"])
end


Rake::GemPackageTask.new(locarails_gemspec) do |pkg|
  pkg.gem_spec = locarails_gemspec
end

namespace :gem do
  namespace :spec do
    desc "Update locarails.gemspec"
    task :generate do
      File.open("locarails.gemspec", "w") do |f|
        f.puts(locarails_gemspec.to_ruby)
      end
    end
  end
end

desc "Generate package and install"
task :install => :package do
  sh %{sudo gem install --local pkg/locarails-#{Locarails::VERSION}}
end

desc "Remove all generated artifacts"
task :clean => :clobber_package