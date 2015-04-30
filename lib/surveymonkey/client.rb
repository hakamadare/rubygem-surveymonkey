require "rest-client"
require "uri"

class Surveymonkey::Client
  extend RestClient

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

      # build the request
      $log.info("Building #{method} request for #{path}...")
      resource = self.resource
      $log.debug(resource.inspect)

      resource.send(method.to_sym, path)
      # make the request
      # self.send(method.to_sym, url.to_s, :params => {:api_key => self.apikey}, :content_type => :json)
      #self.send(method.to_sym, url.to_s, :params => {:api_key => self.apikey}, :headers => {:Authorization => "Bearer #{self.accesstoken}"}, :content_type => :json, :accept => :json})

    rescue Exception => e
      $log.error("Unable to build request URL: #{e.message}")
    end
  end

  def get(*args)
    RestClient.get(*args)
  end

  def put(*args)
    RestClient.put(*args)
  end

  def post(*args)
    RestClient.post(*args)
  end

  def delete(*args)
    RestClient.delete(*args)
  end

  # Private methods
  private

  def initialize(apikey, accesstoken, baseurl = Baseurl)
    @baseurl     = baseurl
    @apikey      = apikey
    @accesstoken = accesstoken

    $log.debug("baseurl: #{baseurl}")
    $log.debug("apikey: #{apikey}")
    $log.debug("apikey: #{accesstoken}")

    begin
      @url = URI(baseurl)
      $log.debug("url: #{@url.to_s}")

      RestClient.log = $log

      @apiresource = _apiresource

    rescue Exception => e
      $log.error("Unable to initialize API client: #{e.message}")
      raise
    end
  end

  def _apiresource
    begin
      url         = self.url
      apikey      = self.apikey
      accesstoken = self.accesstoken

      $log.info("Building API resource...")
      resource = RestClient::Resource.new(url, :api_key => apikey, :headers => { :authorization => "bearer #{accesstoken}", :content_type => 'application/json' })
      $log.debug(resource.inspect)

      resource

    rescue Exception => e
      $log.error("Unable to build API resource: #{e.message}")
      raise
    end
  end

end
