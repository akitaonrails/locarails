module Capistrano
  module Deploy
    module Strategy
      class Base
        protected 
        # A wrapper for Kernel#system that logs the command being executed.
        def system(*args)
          cmd = args.join(' ')
          if RUBY_PLATFORM =~ /win32/
            cmd.gsub!('/','\\') # Replace / with \\
            cmd.gsub!(/^cd /,'cd /D ') # Replace cd with cd /D
            cmd.gsub!(/&& cd /,'&& cd /D ') # Replace cd with cd /D
            cmd.gsub!('%%', '/') # Avoid windows command line parameters to be erroneously replaced by backslashes
            logger.trace "executing locally: #{cmd}"
            super(cmd)
          else
            logger.trace "executing locally: #{cmd}"
            super
          end
        end
      end
    end
  end
end
