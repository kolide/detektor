# frozen_string_literal: true

require "detektor/client_hints"
require "detektor/result"

describe Detektor::ClientHints do
  # parsing ----
  it "returns a result" do
    result = subject.detect({"Sec-CH-UA-Form-Factors" => "Mobile"})
    expect(result).to be_a(Detektor::Result)
  end
end
