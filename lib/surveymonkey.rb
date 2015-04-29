require "log4r"
require "rest-client"

module Surveymonkey
  autoload :Client, 'surveymonkey/client'
  autoload :Version, 'surveymonkey/version'

  include Log4r

  # Constants

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
end
