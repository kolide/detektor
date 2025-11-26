require "detektor/client_hints/parser"
require "detektor/client_hints/form_factor"
require "rspec/support/object_formatter"
require "pp"
require "yaml"
describe Detektor::ClientHints do
  puts RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length
  capture_file = File.join(__dir__, "../header_capture.yml")
  header_captures = YAML.load_file(capture_file)

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
        if capture["chresult"].nil?
          pending("No ch result generated for this capture yet, generating")
          result = subject.parse_headers(capture["headers"])
          pretty = PP.pp(result, "")
          puts pretty
          raise "Wrote result to capture [#{capture["name"]}]\nif this seems incorrect, fix the bug and try again:\n\n#{pretty}"
        end
      end
    end

    if edited
      #File.write(capture_file, header_captures.to_yaml)
    end
  end
end
