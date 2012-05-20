require 'jewelbox/ext/object'
require 'yaml'
module Jewelbox

  # === Description
  # Configure the current process with the configuration items stored in
  # conf/service.yml file from the current working directory.
  #
  # === Parameters
  # None
  #
  # === Returns
  # After this call, you can access the following configuration items
  #
  # Jewelbox.config.service.name     => name of the service (e.g. "taskmon")
  # Jewelbox.config.service.root_dir => everything else is relative to this
  # Jewelbox.config.service.conf_dir
  # Jewelbox.config.service.log_dir
  # Jewelbox.config.service.bin_dir
  # Jewelbox.config.service.lib_dir
  #
  # Also anything that's in service.yml will be accessible from
  # Jewelbox::Service.config object.
  #
  def self.service_init
    @service_root = ENV['SERVICE_ROOT'] || Dir.pwd
    Config.load(File.join(@service_root,'conf','service.yml'))
    @config.add('service', 'root_dir', @service_root)
    @config.add('service', 'conf_dir', File.join(@service_root, 'conf'))
    @config.add('service', 'log_dir',  File.join(@service_root, 'log'))
    @config.add('service', 'bin_dir',  File.join(@service_root, 'bin'))
    @config.add('service', 'lib_dir',  File.join(@service_root, 'lib'))
    @config
  end

  # === Description
  # All configuration files can be accessed through this.
  #
  def self.config
    @config ||= Config.new
  end

  # === Description
  # Configuration object that represents ALL configuration items
  # to be used by the current service process
  #
  class Config

    # === Description 
    # Read the given YAML file, and add its content to Jewelbox.config.
    #
    def self.load(yml_path)
      abs_path = File.expand_path(yml_path)
      h = YAML::load(File.read(yml_path))
      h.each do |section, inner|
        inner.each do |directive, v|
          Jewelbox.config.add(section, directive, v)
        end
      end
    end

    # === Description
    # Inner class that represents a section
    #
    class Section
      def initialize(name)
        @name = name
        @data = {}
      end
      def add(key, value)
        @data[key] = value
        eigenclass.send(:define_method, key) { value }
      end
    end

    def initialize # :nodoc:
      @section = {}
    end

    # === Description
    # Add a configuration item to configuration object
    #
    # === Parameters
    # section_name::   [String] section name
    # directive_name:: [String] directive name
    # value::          [Object] configuration value
    #
    # === Returns
    # Config object self
    #
    def add(section_name, directive_name, value)
      section = @section[section_name]
      if section.nil?
        section = (@section[section_name] = Section.new(section_name))
        eigenclass.send(:define_method, section_name) { section }
      end
      section.add(directive_name, value)
      self
    end

  end # Config
end # Jewelbox
