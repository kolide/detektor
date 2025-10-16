module Detektor
  module Detect
    Option = Data.define :purpose

    IsMobile = Option["is a mobile device"]
    ExactMobileDevice = Option["id mobile device as specifically as possible"]
    InstallBinaries = Option["os and arch for selecting installation packages"]
  end
end
