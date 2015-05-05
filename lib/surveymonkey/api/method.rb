require 'surveymonkey/logging'

##
# Object representing a SurveyMonkey API method.

class Surveymonkey::API::Method
  attr_reader :path, :http_method

  ##
  # Create a new method.  Does some input validation to make sure the
  # associated HTTP method is valid.

  def initialize(path, http_method = 'post')
    begin
      $log.debug(sprintf("%s: enter", __method__))

      # FIXME validate the path
      @path = path

      # validate the method
      $log.debug(sprintf("%s:http_method: '%s'\n", __method__, http_method))
      the_method = http_method.to_s.downcase
      $log.debug(sprintf("%s:the_method: '%s'\n", __method__, the_method))

      if the_method =~ /^(get|post|patch|put|delete|move|copy|head|options)$/
        @http_method = the_method
        $log.debug(sprintf("%s: method: %s", __method__, the_method))
      else
        raise StandardError, "'#{the_method}' is not a valid HTTP method", caller
      end

    rescue StandardError => e
      $log.error(sprintf("%s: unable to initialize API method: %s\n", __method__, e.message))
      raise
    end
  end
end
