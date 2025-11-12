module Detektor
  module ClientHints
    FormFactor = Data.define :name do
      def ==(other)
        other.class == self.class && name.casecmp?(other.name)
      end
    end
    module FormFactors
      Desktop = FormFactor["Desktop"]
      Automotive = FormFactor["Automotive"]
      Mobile = FormFactor["Mobile"]
      Tablet = FormFactor["Tablet"]
      XR = FormFactor["XR"]
      EInk = FormFactor["EInk"]
      Watch = FormFactor["Watch"]
    end
  end
end
