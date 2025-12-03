module Detektor
  module ClientHints
    ##
    # A Data representing a form factor
    # 
    # When ==, casing of the name is ignored.
    FormFactor = Data.define :name do
      def ==(other)
        other.class == self.class && name.casecmp?(other.name)
      end
    end
    
    # Set of known form factors as describe in the formal client hints spec.
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
