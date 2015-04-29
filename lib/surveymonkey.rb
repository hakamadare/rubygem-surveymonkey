require "log4r"
require "rest-client"

module Surveymonkey
  autoload :Client, 'surveymonkey/client'
  autoload :Version, 'surveymonkey/version'

  include Log4r

  # initialize logging
  $log = Logger.new('surveymonkey')
  # FIXME make this configurable
  Loglevel = ERROR

  begin
    # configure logging
    $log.outputters = Outputter.stderr

    $log.level = Loglevel
    $log.debug("Configured logging to stderr.")
  rescue Exception => e
    $stderr.puts("Unable to configure logging: #{e.message}")
    raise
  end

  class << self
    # Constants
    begin
      Apikey      = ENV.fetch('SURVEYMONKEY_APIKEY')
      Accesstoken = ENV.fetch('SURVEYMONKEY_ACCESSTOKEN')
    rescue IndexError => e
      $log.fatal("Missing API credential")
      $log.fatal(e.message)
      raise
    rescue Exception => e
      $log.fatal(e.message)
      raise
    end

    # Public methods

    # Private methods
    private

    def _client
      begin
        @client = Surveymonkey::Client.new(apikey = Apikey, accesstoken = Accesstoken)
      rescue Exception => e
        $log.fatal("Unable to initialize REST client: #{e.message}")
        raise
      end
    end
  end

end
