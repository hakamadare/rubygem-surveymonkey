require "httparty"
require "json"
require "uri"

require "surveymonkey/logging"

class Surveymonkey::Client
  include HTTParty

  $log.debug("Defined Surveymonkey::Client.")

  # Constants
  Baseurl = 'https://api.surveymonkey.net'

  Endpoints = {
    'get_survey_list' => {
      'method' => 'post',
      'path'   => '/v2/surveys/get_survey_list',
    },
  }

  # Public methods
  attr_reader :url, :apikey, :accesstoken, :apiresource

  def api_request(endpoint, endpoints = Endpoints)
    $log.debug("endpoint: #{endpoint}")

    begin
      path = endpoints[endpoint]['path']
      $log.debug("path: #{path}")

      method = endpoints[endpoint]['method']
      $log.debug("method: #{method}")

      params = "?api_key=#{apikey}"

      # build the request
      $log.info("Building #{method} request for #{path}...")

      request_url = URI.join(self.baseurl, path, params).to_s
      $log.debug(request_url)

      # make the request
      $log.debug(self.class.public_methods)
      self.class.post request_url, @options

    rescue Exception => e
      $log.error("Unable to build request URL: #{e.message}")
      raise
    end
  end

  # Private methods
  private

  def initialize(apikey, accesstoken, baseurl = Baseurl)
    @baseurl     = baseurl
    @apikey      = apikey
    @accesstoken = accesstoken

    $log.debug("baseurl: #{baseurl}")
    $log.debug("apikey: #{apikey}")
    $log.debug("accesstoken: #{accesstoken}")

    begin
      self.class.logger $log, :debug, :curl

      @headers = {
        "Content-Type"  => "application/json",
        "Authorization" => "bearer #{accesstoken}",
      }
      self.class.headers @headers

    rescue Exception => e
      $log.error("Unable to initialize API client: #{e.message}")
      raise
    end
  end

  def _apiresource
    begin
      url         = self.url.to_s
      apikey      = self.apikey
      accesstoken = self.accesstoken

      $log.info("Building API resource...")
      resource = RestClient::Resource.new(url, :api_key => apikey, :accept => 'application/json', :headers => { :authorization => "bearer #{accesstoken}" })
      $log.debug(resource.inspect)

      resource

    rescue Exception => e
      $log.error("Unable to build API resource: #{e.message}")
      raise
    end
  end

end
