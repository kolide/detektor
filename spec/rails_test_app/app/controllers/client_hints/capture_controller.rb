require "detektor"
require "pp"
module ClientHints
  class CaptureController < ApplicationController
    def index
      Detektor::ClientHints::ResponseBuilder.detecting(Detektor::Everything).apply_headers(response.headers)
      ch_result = Detektor.detect(request.headers)
      filtered_headers = ActionDispatch::Http::Headers.from_hash(request.headers.to_h.filter { |k, v| k.starts_with?("HTTP_") })
      output = "Pretty printed:\n"
      output << PP.pp(ch_result, "")
      output << "\n\n"
      output << "If everything looks correct you can copy the following to the test file."
      output << "\nMake sure to replace the name with something useful, like: John Macbook Chrome or Sally SamsungTestPhone Brave\n\n"
      output << [{"name" => "REPLACE ME", "headers" => filtered_headers, "ch_result" => ch_result}].to_yaml
      Rails.logger.info(output)
      render plain: output
    end
  end
end
