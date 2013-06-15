require 'bundler/gem_tasks'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include %w[ lib/vimprint/ragel ]

task :ragel do
  out_dir = File.expand_path('../lib/vimprint/ragel', __FILE__)
  Dir.mkdir(out_dir) unless Dir.exist?(out_dir)
  Dir.chdir('ext/ragel') do
    Dir['*.rl'].each do |file|
      out = file.sub(/rl$/, 'rb')
      sh "ragel -R #{file} -o #{out_dir}/#{out}"
    end
  end
end

Rake::TestTask.new(:test => :ragel) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

desc "Run tests"
task :default => :test
