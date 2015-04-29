require "logging"
require "rest-client"

require "surveymonkey/version"

module Surveymonkey
  autoload :Client, "surveymonkey/client"

  # initialize logging
  # FIXME make this configurable
  if ENV.member?('SURVEYMONKEY_LOGLEVEL')
    Loglevel = ENV['SURVEYMONKEY_LOGLEVEL'].to_sym
  else
    Loglevel = :error
  end

  begin
    # configure logging
    $log = Logging.logger(STDERR)

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
    def get_survey_list
      begin
        client = _client
      rescue Exception => e
        $log.error(e.message)
        raise
      end
    end

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
