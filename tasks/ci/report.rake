namespace "ci" do
  def add_summary(content)
    sh "echo '#{content}' >> $GITHUB_STEP_SUMMARY"
  end

  def add_note(level, message)
    sh "echo ::#{level}::#{message}"
  end

  def annotate_test_error(title, message, file, line)
    sh "echo ::error file=#{file},line=#{line},title=#{title}::#{message}"
  end
  task "test_report" do
    require "json"
    # coverage
    coverage_dir = File.expand_path("../../coverage", __dir__)
    last_run = File.join(coverage_dir, ".last_run.json")
    if File.exist?(last_run)
      content = File.read(last_run)
      parsed = JSON.parse!(content)
      add_summary("\n#### Coverage\n")
      parsed["result"].each do |k, v|
        add_summary("\n #{key} coverage - #{v}%\n")
      end
    else
      add_note("warning", "No coverage file found at #{last_run}")
    end

    # test
    report = File.expand_path("../../spec/reports/results.json", __dir__)
    if File.exist?(report)
      content = File.read(report)
      parsed = JSON.parse!(content)
      add_summary("\n#### Test results\n")
      add_summary("#{parsed["summary_line"]}\n")
      parsed["examples"].each do |example|
        puts example["id"]
        if example["staus"] == "failed"
          exception = example["exception"]
          annotate_test_error(
            exception["message"],
            exception["backtrace"],
            example["file_path"],
            example["line_number"]
          )
        end
      end
    else
      add_note("warning", "No test report file found at #{report}")
    end
  end
end
