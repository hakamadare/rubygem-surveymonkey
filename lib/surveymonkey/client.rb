require "rest-client"
require "uri"

class Surveymonkey::Client
  extend RestClient

  $log.debug("Defined Surveymonkey::Client.")

  # Constants
  Baseurl = 'https://api.surveymonkey.net'
  Apiversion = '2'

  # Public methods
  attr_reader :url

  def get(url, *params)
    RestClient.get(url, *params)
  end

  def put(url, *params)
    RestClient.put(url, *params)
  end

  def post(url, *params)
    RestClient.post(url, *params)
  end

  def delete(url, *params)
    RestClient.delete(url, *params)
  end

  # Private methods
  private

  def initialize(baseurl = Baseurl, apiversion = Apiversion)
    @baseurl    = baseurl
    @apiversion = apiversion

    $log.debug("baseurl: #{baseurl}")
    $log.debug("apiversion: #{apiversion}")

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
