class Capistrano::Deploy::SCM::None
  # Simply does a copy from the :repository directory to the
  # :destination directory.
  def checkout(revision, destination)
    !Capistrano::Deploy::LocalDependency.on_windows? ? "cp -R #{repository} #{destination}" : "xcopy \"#{repository.gsub('/', '\\')}\" \"#{destination}\" /I /Y /Q /E"
  end

  alias_method :export, :checkout
end