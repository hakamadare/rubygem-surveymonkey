require "logging"

require "surveymonkey/version"
require "surveymonkey/logging"

module Surveymonkey
  autoload :Client, "surveymonkey/client"

  class << self
    # Constants

    # Public methods
    def method_missing(method_name, *args)
      begin
        $log.debug(sprintf("%s: %s\n", __method__, 'enter'))

        # response = _client.api_call('get_survey_list', method_params)
        response = _client.send(:api_call, method_name.to_s, args)
        response

      rescue KeyError => e
        $log.fatal(sprintf("%s: method '%s' not implemented\n"))
        exit 1
      rescue Exception => e
        $log.error(sprintf("%s: %s\n", __method__, e.message))
        raise
      end
    end

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
