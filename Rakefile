# frozen_string_literal: true

require "rake"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
Dir["lib/tasks/*.rake"].each { |rake| load rake }

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end

if ENV['CI'] && ENV['QUALITY'] == 'false'
  task default: 'spec'
elsif defined?(RUBY_ENGINE) && RUBY_ENGINE == 'ruby'
  task default: 'spec:quality'
else
  task default: 'spec'
end
