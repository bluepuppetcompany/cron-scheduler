# -*- encoding: utf-8 -*-
Gem::Specification.new do |spec|
  spec.name = 'cron-scheduler'
  spec.version = '0.0.0'
  spec.summary = 'Cron Scheduler'
  spec.description = ' '

  spec.authors = ['Joseph Choe']
  spec.email = ['joseph@josephchoe.com']
  spec.homepage = 'https://github.com/bluepuppetcompany/cron-scheduler'

  spec.require_paths = ['lib']
  spec.files = Dir.glob('{lib}/**/*')
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.6'

  spec.add_runtime_dependency 'ntl-actor'
  spec.add_runtime_dependency 'parse-cron'

  spec.add_runtime_dependency 'evt-clock'
  spec.add_runtime_dependency 'evt-dependency'
  spec.add_runtime_dependency 'evt-log'

  spec.add_development_dependency 'test_bench'
end
