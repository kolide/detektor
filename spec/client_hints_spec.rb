# frozen_string_literal: true

require "detektor/client_hints"
require "detektor/constants"

HEADERS = Detektor::ClientHints::HEADERS
RESULT_KEYS = Detektor::Constants::Result

RSpec.shared_examples "a parser of the client hint header" do |header, result_key, cases|
  describe header do
    cases.each do |test_case|
      givens = test_case[:given].is_a?(Array) ? test_case[:given] : [test_case[:given]]
      givens.each do |given|
        it "given #{actual_str(given)} parses to #{actual_str(test_case[:expect])}" do
          result = subject.parse_headers({header => given})
          expect(result[result_key]).to be test_case[:expect]
        end
      end
    end
  end
end

describe Detektor::ClientHints do
  subject { described_class.new }

  it_behaves_like("a parser of the client hint header", HEADERS[:is_mobile], RESULT_KEYS::IS_MOBILE,
    [
      {given: %w[1 ?1 true], expect: true},
      {given: true, expect: true},
      {given: false, expect: false},
      {given: [{}, nil, "blue", 14, [], ""], expect: nil}
    ])




    
end
