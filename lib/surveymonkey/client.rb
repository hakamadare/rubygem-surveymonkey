require "rest-client"

class Surveymonkey::Client
  extend RestClient

  $log.debug("Defined Surveymonkey::Client.")
end
