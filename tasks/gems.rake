locarails_gemspec = Gem::Specification.new do |s|
  s.name = "locarails"
  s.version = Locarails::VERSION::STRING
  s.homepage = "http://www.locaweb.com.br/rails"
  s.summary = "Configuracao de Capistrano automatica para hospedagens Linux Locaweb."
  s.authors = ["Fabio Akita"]
  s.date = %q{Time.now.strftime("%Y/%d/%m")}
  s.default_executable = "locarails"
  s.description = "A maneira mais simples para instalar aplicacoes Rails na hospedagem Linux da Locaweb."
  s.email = "fabio.akita@locaweb.com.br"
  s.executables = ["locarails"]
  s.files = Dir.glob("{bin,lib,templates,tasks}/**/*") + ['templates/.gitignore']
  s.has_rdoc = true
  s.require_paths = ["lib"]

  s.add_runtime_dependency("capistrano", [">= 2.0.0"])
  s.add_runtime_dependency("highline", [">= 0"])
  s.add_runtime_dependency("archive-tar-minitar", [">= 0.5.2"])
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