require "detektor/result"
module Detektor
  module Known
    module Os
      Android = Result::Os["Android"]
      ChromeOS = Result::Os["Chrome Os"]
      Fuschia = Result::Os["Fuschia"]
      Ios = Result::Os["iOS"]
      Linux = Result::Os["Linux"]
      MacOS = Result::Os["macOS"]
      Windows = Result::Os["Windows"]
      Unknown = Result::Os["Unknown"]
    end
  end
end
