require "detektor/client_hints/parser"
require "detektor/header_wrapper"
require "detektor/client_hints/form_factor"
require "rspec/support/object_formatter"
require "action_dispatch"
require "pp"
require "yaml"
describe Detektor::ClientHints do
  capture_file = File.join(__dir__, "../header_capture.yml")
  header_captures = YAML.unsafe_load_file(capture_file)

  edited = false
  seen_names = Set.new
  header_captures.each do |capture|
    if seen_names.include?(capture["name"])
      puts "Saw name duplicate [#{capture["name"]}], editing name"
      capture["name"] << Random.nextInt(7000)
      edited = true
    end
    seen_names.add(capture["name"])

    describe "with capture #{capture["name"]}" do
      it "matches stored CHResult" do |example|
        result = subject.detect(Detektor::HeaderWrapper.new(capture["headers"])).ch_result
        expect(result).to eq(capture["ch_result"])
      end
    end

    if edited
      File.write(capture_file, header_captures.to_yaml)
    end
  end
end
