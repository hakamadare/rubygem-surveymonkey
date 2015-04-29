require "rest-client"
require "uri"

class Surveymonkey::Client
  extend RestClient

  $log.debug("Defined Surveymonkey::Client.")

  # Constants
  Baseurl = 'https://api.surveymonkey.net'
  Apiversion = '2'

  Endpoints = {
    :get_survey_list => {
      :method => 'get',
      :path   => '/surveys/get_survey_list',
    },
  }

  # Public methods
  attr_reader :url, :apikey, :accesstoken

  def api_request(endpoint, endpoints = Endpoints)
    $log.debug("endpoint: #{endpoint}")

    begin
      path = endpoints[:endpoint][:path]
      $log.debug("path: #{path}")
      method = endpoints[:endpoint][:method]
      $log.debug("method: #{method}")

      url = URI.join(self.url, path)
      $log.debug("url: #{url.to_s}")

      payload = {
        :content_type => 'application/json',
        :Authorization => "Bearer #{self.accesstoken}",
        :params => {:api_key => self.apikey},
      }
      $log.debug("payload: #{payload.inspect}")

      # make the request
      self.send(method.to_sym, url.to_s, payload)

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

  def initialize(apikey, accesstoken, baseurl = Baseurl, apiversion = Apiversion)
    @baseurl     = baseurl
    @apiversion  = apiversion
    @apikey      = apikey
    @accesstoken = accesstoken

    $log.debug("baseurl: #{baseurl}")
    $log.debug("apiversion: #{apiversion}")
    $log.debug("apikey: #{apikey}")
    $log.debug("apikey: #{accesstoken}")

    begin
      $log.debug("Building API URL")
      @url = URI("#{baseurl}/v#{apiversion}")
      $log.debug("url: #{@url.to_s}")
    rescue Exception => e
      $log.error("Unable to build API URL: #{e.message}")
      raise
    end
  end

end
