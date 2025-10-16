# frozen_string_literal: true

require "detektor/client_hints"
require "detektor/result"

HEADERS = Detektor::ClientHints::HEADERS

describe Detektor::ClientHints do
  subject { described_class.new }

  # parsing ----

  shared_examples "a parser of" do |header, examples|
    describe header do
      examples.each do |example|
        describe "parses to #{actual_str(example[0])}" do
          example[1].each do |input|
            it "from #{actual_str(input)}" do
              result = subject.parse_headers({header => input})
              expect(result.values.first).to eq example[0]
            end
          end
        end
      end
    end
  end

  it_behaves_like "a parser of", HEADERS[:is_mobile], [
    [true, ["1", "?1", "true", true]],
    [false, ["0", "?0", "false", false]],
    [nil, [{}, nil, "blue", 14, [], ""]]
  ]

  it_behaves_like "a parser of", HEADERS[:platform], [
    [Detektor::Known::Os::Android, ["Android", "android", "ANDROID"]],
    [Detektor::Known::Os::Ios, ["ios", "iOS", "IOS"]]
  ]
end
