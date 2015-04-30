require "logging"
require "rest-client"

require "surveymonkey/version"
require "surveymonkey/logging"

module Surveymonkey
  autoload :Client, "surveymonkey/client"

  class << self
    # Constants
    begin
      Apikey      = ENV.fetch('SURVEYMONKEY_APIKEY')
      Accesstoken = ENV.fetch('SURVEYMONKEY_ACCESSTOKEN')
    rescue IndexError => e
      $log.fatal("Missing API credential")
      $log.fatal(e.message)
      raise
    rescue Exception => e
      $log.fatal(e.message)
      raise
    end

    # Public methods
    def get_survey_list
      $log.debug("Entering get_survey_list")
      begin
        client = _client

        response = _client.api_request('get_survey_list')
      rescue Exception => e
        $log.error(e.message)
        raise
      end
    end

    # Private methods
    private

    def _client
      begin
        @client = Surveymonkey::Client.new(apikey = Apikey, accesstoken = Accesstoken)
      rescue Exception => e
        $log.fatal("Unable to initialize REST client: #{e.message}")
        raise
      end
    end
  end

end
