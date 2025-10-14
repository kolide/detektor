namespace "git:hooks" do
  git_hooks = %w[pre-push pre-commit]

  git_hooks.each do |gh|
    t = Rake::Task.define_task("setup:#{gh}") do
      out_file = ".git/hooks/#{gh}"
      in_file = "tasks/git/template.#{gh}"
      touch out_file
      cp in_file, out_file
      chmod 0o755, out_file
    end
    t.add_description "sets up the #{gh} git hook from template.#{gh}"
  end

  task setup: git_hooks.map { |gh| "setup:#{gh}" }
end
