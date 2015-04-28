class Surveymonkey::Config
  attr_accessor :apiversion, :baseurl

  def initialize(baseurl = 'https://api.surveymonkey.net', apiversion = '2')
    @baseurl = baseurl
    @apiversion = apiversion

    @apiurl = "#{baseurl}/v#{apiversion}"
  end
end
