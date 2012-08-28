require 'jewelbox/ext/object'
require 'jewelbox/ext/string'
require 'optparse'
module Jewelbox

  # === Description
  # Simple wrapper around Ruby OptionParser to factor out common code that
  # you have to repeat every time you write a command line tool. This is a
  # simple wrapper. There is minimum additional functionality.
  #
  # === Example Code
  # Creating a new command line tool or service runner.
  #
  # class MyApp < Jewelbox::Command
  #
  #   class MyCustomException < RuntimeError; end
  #   exit_code 1, RuntimeError,      "Unexpected error"
  #   exit_code 2, MyCustomException, "Some good explanation"
  #
  #   def initialize
  #     @address = "default address"
  #     @name    = "default name"
  #     @arg1    = ""
  #     @arg2    = ""
  #   end
  #
  #   def define_options(opt)
  #     opt.banner = "Usage: #{opt.program_name} [options] arg1 arg2"
  #     opt.on("-a addr", "--address addr", String, "Address to work with") {|s| @address = s}
  #     opt.on("-n name", "--name name", String, "Name to work with")       {|s| @name = s}
  #   end
  #
  #   # Main entry point of the application
  #   #
  #   def main(argv)
  #     @arg1 = argv[0]
  #     @arg2 = argv[1]
  #     # write application code here
  #   end
  #
  # end
  #
  # MyApp.new.run
  #
  # === Help Output Example
  # With the above example, you will get the following help text:
  #
  # Usage: myapp [options] arg1 arg2
  #     -a, --address addr               Address to work with
  #     -n, --name name                  Name to work with
  #     -h, --help                       Display help
  #     -v, --verbose                    Verbose output
  #
  # Exit codes:
  #      1 [RuntimeError]                Unexpected error
  #      2 [MyApp::MyCustomException]    Some good explanation
  #
  # === Notes
  #
  # 1. The following options are automatically added.
  #   opt.on("-h", "--help",    "Display help")   { @help = true }
  #   opt.on("-v", "--verbose", "Verbose output") { @verbose = true }
  #
  # 2. You can map exception type to exit code by using exit_code method
  #    When exception happens during "run", we exit with the matching exit code (default = 1)
  #    Also, exception message + "[ERROR]" will be displayed to STDERR.
  #
  # 3. Make sure to override "define_options" and "main" methods.
  #
  class Command
    @@exit_code_map = {}

    # === Description
    # Maps exception class to the exit code.
    #
    # === Parameters
    # number:: (Integer) exit code to return on given exception
    # eClass:: (Class) exception class
    # message:: (String) explanation of the exception
    #
    def self.exit_code(number, eClass, message = "")
      @@exit_code_map[eClass] = [number.to_i, eClass, message]
    end

    private

    def default_options(opt) # :nodoc:
      opt.on("-h", "--help", "Display help")      {@help = true}
      opt.on("-v", "--verbose", "Verbose output") {@verbose = true}
    end

    def define_exit_codes(opt) # :nodoc:
      opt.separator ""
      arr = @@exit_code_map.values.sort {|a,b| a[0] <=> b[0]}
      unless arr.empty?
        opt.separator "Exit codes:"
        arr.each do |code, eClass, msg|
          opt.separator "%6d %-29s %s" % [code, "[#{eClass}]", msg]
        end
      end
    end

    public

    # === Description
    # Your application should override this method.
    # Define application command line options.
    #
    # === Parameters
    # opt:: (OptionParser) use this to define options
    #
    def define_options(opt)
      # override this; no additional options by default
    end

    # === Description
    # Your application should override this method.
    # Implement the main entry point.
    #
    # === Parameters
    # argv:: (Array) of positional arguments
    #        Basically left over after processing command line options
    #        starting with dash(s) as defined in get_options.
    #
    # === Returns
    # (Integer) exit code
    #
    def main(argv)
      # override this; no default action in main
    end

    # === Description
    # Parse options, and run the main method
    # 
    # === Returns
    # (Integer) exit code
    #
    def run
      code = 0
      opt = OptionParser.new
      define_options(opt)
      default_options(opt)
      define_exit_codes(opt)
      argv = opt.parse!

      if @help
        puts_msg(opt.help)

      else
        begin
          main(argv)
        rescue Exception => e
          arr = @@exit_code_map[e.class]
          code = arr ? arr[0] : 1
          puts_err e.to_s
          puts_err "[ERROR]"
        end
      end

      exit(code)
    end

    # === Description
    # Print out msg to STDOUT
    #
    def puts_msg(msg)
      STDOUT.puts(msg)
    end

    # === Description
    # Print out msg to STDERR in red color
    #
    def puts_err(msg)
      STDERR.puts(msg.to_s.red)
    end

  end
end

