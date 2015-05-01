require "httparty"
require "json"
require "uri"

require "surveymonkey/logging"

class Surveymonkey::Client
  include HTTParty

  $log.debug("Defined Surveymonkey::Client.")

  # constants
  Baseuri = 'https://api.surveymonkey.net'
  Api_methods = {
    'get_survey_list' => {
      'path'   => '/v2/surveys/get_survey_list',
      'method' => 'post',
    }
  }

  # public methods
  attr_reader :baseuri, :access_token, :api_key, :loglevel

  def api_call(api_method, method_params = {}, api_key = self.api_key, access_token = self.access_token)
    begin
      $log.debug(sprintf("%s: calling '%s'\n", __method__, api_method))

      the_api_method = _api_method(api_method)

      body        = _api_method_params(method_params)

      path        = the_api_method.fetch('path')

      http_method = the_api_method.fetch('method', 'get')

      $log.debug(sprintf("%s: %s '%s' '%s'\n", __method__, http_method, path, body))

      http_headers = _http_headers(access_token)
      $log.debug(sprintf("%s: http_headers: '%s'\n", __method__, http_headers.inspect))

      request_uri = _request_uri(path, api_key)

      $log.debug(sprintf("%s: ready to make request for '%s'\n", __method__, api_method))
      response = self.class.send(http_method.to_sym, request_uri, body: body, headers: http_headers)

      $log.debug(sprintf("%s: response class %s\n", __method__, response.class))
      $log.debug(sprintf("%s: response code %i\n", __method__, response.code))
      $log.debug(sprintf("%s: response headers '%s'\n", __method__, response.headers.inspect))

      response.parsed_response

    rescue Exception => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

  def initialize(*args)
    begin
      param_hash = args.shift || {}
      @baseuri      = param_hash.fetch('baseuri', Baseuri)
      @access_token = param_hash.fetch('access_token', _from_env('SURVEYMONKEY_ACCESSTOKEN'))
      @api_key      = param_hash.fetch('api_key', _from_env('SURVEYMONKEY_APIKEY'))
      @loglevel     = param_hash.fetch('api_key', _from_env('SURVEYMONKEY_LOGLEVEL'))

      $log.debug(sprintf("%s: setting loglevel to '%s'\n", __method__, @loglevel))
      self.class.logger $log, @loglevel.to_sym

      $log.debug(sprintf("%s: setting base_uri to '%s'\n", __method__, @baseuri))
      self.class.base_uri @baseuri

      $log.debug(sprintf("%s: setting headers'\n", __method__))
      the_headers = {
        "Content-Type"  => "application/json",
        "Authorization" => sprintf("bearer %s", @access_token),
      }
      self.class.headers the_headers
    rescue Exception => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

  # private methods
  private

  def _api_method(key, api_methods = Api_methods)
    begin
      $log.debug(sprintf("%s: fetching '%s' from api methods\n", __method__, key))
      value = api_methods.fetch(key)
      $log.debug(sprintf("%s: retrieved '%s'\n", __method__, value.inspect))
      value

    rescue KeyError => e
      $log.error(sprintf("%s: '%s' not found in api methods\n", __method__, key))
    rescue Exception => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

  def _http_headers(token)
    begin
      $log.debug(sprintf("%s: constructing http headers with token '%s'\n", __method__, token))
      http_headers = {
        "Content-Type" => "application/json",
        "Authorization" => sprintf("bearer %s", token),
      }
      $log.debug(sprintf("%s: http headers: '%s'\n", __method__, http_headers))
      http_headers

    rescue Exception => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

  def _api_method_params(method_params)
    begin
      $log.debug(sprintf("%s: parsing api method params from '%s'\n", __method__, method_params))
      the_params = JSON.generate(method_params || {}).to_s
      $log.debug(sprintf("%s: parsed method params '%s'\n", __method__, the_params))
      the_params

    rescue Exception => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

  def _request_uri(path, api_key)
    begin
      $log.debug(sprintf("%s: generating request uri fragment from '%s' and '%s'\n", __method__, path, api_key))
      request_uri = sprintf("%s?api_key=%s", path, api_key)
      $log.debug(sprintf("%s: generated '%s'\n", __method__, request_uri))
      request_uri

    rescue Exception => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

  def _from_env(key)
    begin
      $log.debug(sprintf("%s: fetching '%s' from environment\n", __method__, key))
      value = ENV.fetch(key)
      $log.debug(sprintf("%s: retrieved '%s'\n", __method__, value))
      value

    rescue KeyError => e
      $log.info(sprintf("%s: '%s' not found in environment\n", __method__, key))
    rescue Exception => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

end
