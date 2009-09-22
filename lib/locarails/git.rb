class Capistrano::Deploy::SCM::Git
  alias :checkout_old :checkout
  def checkout(revision, destination)
    sub_wrapper(:checkout_old, revision, destination)
  end
  
  alias :sync_old :sync
  def sync(revision, destination)
    sub_wrapper(:sync_old, revision, destination)
  end
  
  def sub_wrapper(method, revision, destination)
    execute = send(method, revision, destination) # execute original method
    # filter the git URL to force it to a local file:// URL
    execute.collect do |line|
      if line.include?(configuration[:repository])
        line.sub(configuration[:repository], remote_repository)
      else
        line
      end
    end
  end
  
  # force the remote git commands to fetch from the local filesystem instead
  # making a round-trip to itself through ssh
  def remote_repository
    url = "#{configuration[:user]}@#{configuration[:domain]}:"
    @remote_repository ||= if configuration[:repository].include?(url)
      tmp = configuration[:repository].sub(url, "file://")
      if tmp.include?("~")
        tmp.sub!("~", "/home/#{configuration[:user]}")
      end
      tmp
    else
      configuration[:repository]
    end
    @remote_repository
  end
end
