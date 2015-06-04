require "httparty"
require "json"

require "surveymonkey/logging"

##
# Class encapsulating the HTTParty client used to communicate with the SurveyMonkey API.

class Surveymonkey::Client
  include HTTParty

  $log.debug("Defined Surveymonkey::Client.")

  # constants

  # public methods
  attr_reader :baseuri, :api_key, :access_token

  ##
  # Create a new Surveymonkey::Client object.  Requires the following parameters:
  # * baseuri
  # * access_token
  # * api_key

  def initialize(baseuri, access_token, api_key)
    begin
      @baseuri      = baseuri
      @access_token = access_token
      @api_key      = api_key

      self.class.logger $log, :debug

      $log.debug(sprintf("%s: setting base_uri to '%s'", __method__, @baseuri))
      self.class.base_uri @baseuri

      http_headers = _http_headers(@access_token)
      self.class.headers http_headers

    rescue StandardError => e
      $log.error(sprintf("%s: %s", __method__, e.message))
      raise e
    end
  end

  ##
  # Stringify a Surveymonkey::Client object

  def to_s
    self.baseuri
  end

  # private methods
  private

  def _http_headers(token) #:nodoc:
    begin
      $log.debug(sprintf("%s: constructing http headers with token '%s'", __method__, token))
      http_headers = {
        "Content-Type" => "application/json",
        "Authorization" => sprintf("bearer %s", token),
      }
      $log.debug(sprintf("%s: http headers: '%s'", __method__, http_headers))
      http_headers

    rescue StandardError => e
      $log.error(sprintf("%s: %s", __method__, e.message))
      raise e
    end
  end

end
