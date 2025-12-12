module Detektor
  ##
  # Simple Data to describe options for detection
  #
  # Ideally, we don't need to parse everything
  # available for most types of client detection.
  Purpose = Data.define :desciption

  ##
  # A +Purpose+ of processing all available data.
  # Should be the default for most usages of +Purpose+.
  Everything = Purpose["process all available data"]
  ##
  # A +Purpose+ of determining if the client is a mobile device.
  IsMobile = Purpose["determine if client is a mobile device"]
  ##
  # A +Purpose+ of identifying the client as a specific mobile device,
  # ideally including model identification.
  ExactMobileDevice = Purpose["identify a mobile device as specifically as possible"]
  ##
  # A +Purpose+ of determining which installation packages to present to or select for a user.
  InstallBinaries = Purpose["choose os and arch for presenting or downloading installation packages"]
end
