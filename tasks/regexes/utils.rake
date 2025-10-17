namespace "regex:utils" do
  task "setup" do
    sh "git submodule init"
    mkdir "regexes" unless File.exist? "regexes"
  end

  task :pull, [:which] => ["regex:utils:setup"] do |t, args|
    sh "git submodule update --remote #{args.which}"
  end
end
