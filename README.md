# Jewelbox

Useful Ruby utility classes that handle:

- configuration
- time stamp
- object serialization

## Installation

Add this line to your application's Gemfile:

    gem 'jewelbox'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jewelbox

## Usage

Service Configuration
=====================

If you want to keep your application configuration separate from Rails config,
you might store your configuration in a YAML file under conf/ directory.

1. Suppose you have "/opt/myrailsapp/current/conf/service.yml" that looks like:
  
   ---
   service:
     name: myrailsapp
     read_port: 80
     write_port: 81
     num_workers: 4
   section1:
     directive1: true
     directive2: 100
     directive3:
       key1: val1
       key2: val2

2. Access the configuration file like this:

   # Load service.yml like this
   Jewelbox::Config.load("conf/service.yml")
   -or-
   Jewelbox.service_init               # this will load "conf/service.yml"
                                       # from current working directory
   # Access service configuration
   Jewelbox.config.service.name        => "myrailsapp"
   Jewelbox.config.service.read_port   => 80
   Jewelbox.config.service.write_port  => 81
   Jewelbox.config.service.num_workers => 4
   Jewelbox.config.section1.directive1 => true
   Jewelbox.config.section1.directive2 => 100
   Jewelbox.config.section1.directive3 => {"key1" => "val1", "key2" => "val2"}
   Jewelbox.config.section1            => <Section> object

   # You can dynamically add things to config or section objects
   Jewelbox.config.add("section2", "directive1", "new val")
   Jewelbox.config.add("section2", "directive2", {:a => 20})
   Jewelbox.config.section2.add("directive3", 200)
   Jewelbox.config.section2.directive1 => "new_val"
   Jewelbox.config.section2.directive2 => returns the same object you added
   Jewelbox.config.section2.directive3 => 200

   # some automatic bonus configs
   Jewelbox.config.service.root_dir    => "/opt/myrailsapp/current"
   Jewelbox.config.service.conf_dir    => "/opt/myrailsapp/current/conf"
   Jewelbox.config.service.log_dir     => "/opt/myrailsapp/current/log"
   Jewelbox.config.service.bin_dir     => "/opt/myrailsapp/current/bin"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
