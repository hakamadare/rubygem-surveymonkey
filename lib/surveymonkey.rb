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

        method_params = Hash(Array(args).shift) || {}

        response = _client.send(:api_call, method_name.to_s, method_params)
        response

      rescue TypeError => e
        $log.fatal(sprintf("%s: method parameters must be a hash\n"))
        exit 1
      rescue KeyError => e
        $log.fatal(sprintf("%s: method '%s' not implemented\n"))
        exit 1
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
