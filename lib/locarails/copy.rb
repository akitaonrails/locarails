class Capistrano::Deploy::Strategy::Copy     
  # Obtains a copy of the source code locally (via the #command method),
  # compresses it to a single file, copies that file to all target
  # servers, and uncompresses it on each of them into the deployment
  # directory.
  def deploy!
    if copy_cache
      if File.exists?(copy_cache)
        logger.debug "refreshing local cache to revision #{revision} at #{copy_cache}"
        system(source.sync(revision, copy_cache))
      else
        logger.debug "preparing local cache at #{copy_cache}"
        system(source.checkout(revision, copy_cache))
      end

      logger.debug "copying cache to deployment staging area #{destination}"
      Dir.chdir(copy_cache) do
        FileUtils.mkdir_p(destination)
        queue = Dir.glob("*", File::FNM_DOTMATCH)
        while queue.any?
          item = queue.shift
          name = File.basename(item)

          next if name == "." || name == ".."
          next if copy_exclude.any? { |pattern| File.fnmatch(pattern, item) }

          if File.symlink?(item)
            FileUtils.ln_s(File.readlink(File.join(copy_cache, item)), File.join(destination, item))
          elsif File.directory?(item)
            queue += Dir.glob("#{item}/*", File::FNM_DOTMATCH)
            FileUtils.mkdir(File.join(destination, item))
          else
            FileUtils.ln(File.join(copy_cache, item), File.join(destination, item))
          end
        end
      end
    else
      logger.debug "getting (via #{copy_strategy}) revision #{revision} to #{destination}"
      system(command)

      if copy_exclude.any?
        logger.debug "processing exclusions..."
        if copy_exclude.any?
          copy_exclude.each do |pattern| 
            delete_list = Dir.glob(File.join(destination, pattern), File::FNM_DOTMATCH)
            # avoid the /.. trap that deletes the parent directories
            delete_list.delete_if { |dir| dir =~ /\/\.\.$/ }
            FileUtils.rm_rf(delete_list.compact)
          end
        end
      end
    end

    File.open(File.join(destination, "REVISION"), "w") { |f| f.puts(revision) }

    logger.trace "compressing #{destination} to #{filename}"
    # if it is Windows, force gzip using the pure Ruby minitar library
    if Capistrano::Deploy::LocalDependency.on_windows?
      require 'zlib'
      require 'archive/tar/minitar'
      Dir.chdir(tmpdir) { Archive::Tar::Minitar.pack(File.basename(destination), Zlib::GzipWriter.new(File.open(File.basename(filename), 'wb'))) }
      configuration[:copy_compression] = :gzip
    else
      Dir.chdir(tmpdir) { system(compress(File.basename(destination), File.basename(filename)).join(" ")) }
    end

    upload(filename, remote_filename)
    run "cd #{configuration[:releases_path]} && #{decompress(remote_filename).join(" ")} && rm #{remote_filename}"
  ensure
    FileUtils.rm filename rescue nil
    FileUtils.rm_rf destination rescue nil
  end
end
