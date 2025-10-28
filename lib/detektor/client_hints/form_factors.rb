module Detektor
  module ClientHints
    FormFactor = Data.define :name

    Desktop = FormFactor["Desktop"]
    Auto = FormFactor["Automotive"]
    Mobile = FormFactor["Mobile"]
    Tablet = FormFactor["Tablet"]
    XR = FormFactor["XR"]
    EInk = FormFactor["EInk"]
    Watch = FormFactor["Watch"]
  end
end
