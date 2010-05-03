# RSpec tasks
desc 'Run examples'
task :spec do
  system "cd spec && spec *_spec.rb"
end

# RubyGem tasks
desc 'Build the gem'
task :build do
  system "gem build nagios3.gemspec"
end

desc 'Install the gem locally'
task :install => :build do
  system "gem install nagios3"
end

# desc 'Push the gem to gemcutter'
# task :release => :build do
#   system "gem push nagios3-#{Nagios3::VERSION}"
# end

task :default => :spec
