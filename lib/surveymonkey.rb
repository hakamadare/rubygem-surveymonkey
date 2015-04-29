require "log4r"
require "rest-client"

module Surveymonkey
  autoload :Client, 'surveymonkey/client'
  autoload :Version, 'surveymonkey/version'

  # configure logging
  include Log4r
  begin
    $log = Logger.new('surveymonkey')
    $log.outputters = Outputter.stderr

    # FIXME make log level configurable
    $log.level = DEBUG
    # $log.level = INFO
    $log.debug("Configured logging to stderr.")
  rescue Exception => e
    $stderr.puts("Unable to configure logging: #{e.message}")
    raise
  end
end
