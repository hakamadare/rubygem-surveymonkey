require "logging"

require "surveymonkey/version"
require "surveymonkey/logging"
require "surveymonkey/request"

##
# Top-level module, holds the user-facing methods

module Surveymonkey

  class << self
    # Constants

    # Public methods

    ##
    # Catch-all method; matches SurveyMonkey API method names.  Call like so:
    #  
    #  Surveymonkey.get_user_details({'method_params' => {'foo' => 'bar'}})

    def method_missing(method_name, *args)
      begin
        $log.debug(sprintf("%s: %s\n", __method__, 'enter'))

        method_params = Hash(Array(args).shift) || {}
        $log.debug(sprintf("%s: method_params: %s\n", __method__, method_params.inspect))

        request = Surveymonkey::Request.new(method_name.to_s, method_params)
        response = request.execute
        response

      rescue TypeError => e
        $log.fatal(sprintf("%s: method parameters must be a hash\n", __method__))
        exit 1
      rescue KeyError => e
        $log.fatal(sprintf("%s: method '%s' not implemented\n", __method__, method_name.to_s))
        exit 1
      rescue StandardError => e
        $log.error(sprintf("%s: %s\n", __method__, e.message))
        raise
      end
    end

    # Private methods
    private

  end
end
