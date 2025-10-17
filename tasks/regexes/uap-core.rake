namespace "regex:uap-core" do
  task :update do
    Rake::Task["regex:utils:pull"].invoke("regex-sources/uap-core")

    require "yaml"

    YAML.load_file("regex-sources/uap-core/regexes.yaml")
  end
end
