module Detektor
  ##
  # Not yet used, will eventually wrapp results
  # from multiple sources
  class Result
    attr_accessor :os, :is_mobile, :ch_result

    Unknown = Data.define

    Os = Data.define :name
    Android = Os["Android"]
    ChromeOs = Os["Chrome OS"]
    Ios = Os["iOS"]
    Linux = Os["Linux"]
    MacOS = Os["macOS"]
    Windows = Os["Windows"]
  end
end
