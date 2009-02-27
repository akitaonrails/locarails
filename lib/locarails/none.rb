class Capistrano::Deploy::SCM::None
  # Simply does a copy from the :repository directory to the
  # :destination directory.
  # fix: avoid xcopy parameters to be erroneously replaced by backslashes
  def checkout(revision, destination)
    !Capistrano::Deploy::LocalDependency.on_windows? ? "cp -R #{repository} #{destination}" : "xcopy #{repository} \"#{destination}\" %%S%%I%%Y%%Q%%E"
  end

  alias_method :export, :checkout
end