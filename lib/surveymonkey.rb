require "logging"

require "surveymonkey/version"
require "surveymonkey/logging"

module Surveymonkey
  autoload :Client, "surveymonkey/client"

  class << self
    # Constants

    # Public methods
    def get_survey_list(method_params = {})
      begin
        $log.debug(sprintf("%s: %s\n", __method__, 'enter'))

        response = _client.api_call('get_survey_list', method_params)
        response

      rescue Exception => e
        $log.error(sprintf("%s: %s\n", __method__, e.message))
        raise
      end
    end

    # Private methods
    private

    def _client
      begin
        @client = Surveymonkey::Client.new()
      rescue Exception => e
        $log.fatal(sprintf("%s: %s\n", "Unable to initialize REST client", e.message))
        $log.debug(sprintf("%s: %s\n", __method__, e.message))
        raise
      end
    end
  end

end
