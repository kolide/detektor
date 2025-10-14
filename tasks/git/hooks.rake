namespace "git:hooks" do
  task "pre-push", [:remote, :url] do |t, args|
    Rake::Task["standard"].invoke
  end

  task "pre-commit" do |t, args|
    _staged_files = args.extras
  end
end
