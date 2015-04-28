require "rest-client"

module Surveymonkey
  class Client
    extend RestClient

    attr_accessor :baseurl, :apiversion

    def initialize(baseurl = 'https://api.surveymonkey.net', apiversion = '2')
      @baseurl = baseurl
      @apiversion = apiversion

      @apiurl = "#{baseurl}/v#{apiversion}"
    end
  end
end
