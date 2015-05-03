require "httparty"
require "json"

require "surveymonkey/logging"

class Surveymonkey::Client
  include HTTParty

  $log.debug("Defined Surveymonkey::Client.")

  # constants

  # public methods
  attr_reader :baseuri, :api_key, :access_token

  def initialize(baseuri, access_token, api_key)
    begin
      @baseuri      = baseuri
      @access_token = access_token
      @api_key      = api_key

      self.class.logger $log, :debug

      $log.debug(sprintf("%s: setting base_uri to '%s'\n", __method__, @baseuri))
      self.class.base_uri @baseuri

      $log.debug(sprintf("%s: setting headers'\n", __method__))
      http_headers = _http_headers(@access_token)
      self.class.headers http_headers

    rescue StandardError => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

  # private methods
  private

  def _http_headers(token)
    begin
      $log.debug(sprintf("%s: constructing http headers with token '%s'\n", __method__, token))
      http_headers = {
        "Content-Type" => "application/json",
        "Authorization" => sprintf("bearer %s", token),
      }
      $log.debug(sprintf("%s: http headers: '%s'\n", __method__, http_headers))
      http_headers

    rescue StandardError => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

end
