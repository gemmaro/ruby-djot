# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[copy copy_js test rubocop]

desc "Copy JavaScript files"
task copy_js: "lib/js" do
  license = File.read("vendor/djot.js/LICENSE")
  source = File.read("vendor/djot.js/dist/djot.js")
  File.write("lib/js/djot.js", <<~END_JS)
    #{source}

    /*
    #{license}
    */
  END_JS
end

directory "lib/js"

desc "Copy Lua files"
task copy: "lib/lua/djot" do
  license = File.read("vendor/djot/LICENSE")
  (["vendor/djot/djot.lua"] + Dir["vendor/djot/djot/*.lua"]).each do |file|
    File.write(file.sub(%r{vendor/djot}, "lib/lua"), <<~END_LUA)
      #{File.read(file)}

      --[[
      #{license}
      ]]
    END_LUA
  end
end

directory "lib/lua/djot"

require "rdoc/task"

RDoc::Task.new do |rdoc|
  readme = "README.md"
  rdoc.main = readme
  rdoc.rdoc_files.include(readme, "lib/**/*.rb")
end
