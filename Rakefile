#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake"
require "rake/testtask"

namespace :test do

  Rake::TestTask.new(:unit) do |test|
    test.libs << 'test'
    test.pattern = '{test/unit/**/*_test.rb}'
  end

  Rake::TestTask.new(:all) do |test|
    test.libs << 'test'
    test.pattern = '{test/**/*_test.rb}'
  end

end

task :test    => "test:unit"
task :default => "test"

