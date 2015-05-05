##
# Implement logging for Surveymonkey via the Logging library.
#
# Logging configuration happens at runtime and is drawn from the
# **SURVEYMONKEY_LOGLEVEL** environment variable.  Set this variable to one of
# the standard syslog levels (debug, info, warning, error, fatal) to enable
# more or less logging.  At present Surveymonkey logs a lot of debug messages,
# and other than that just emits errors and fatals if it encounters problems.
# The default loglevel is error.

module Surveymonkey::Logging
  # initialize logging
  if ENV.member?('SURVEYMONKEY_LOGLEVEL')
    Loglevel = ENV['SURVEYMONKEY_LOGLEVEL'].to_sym
  else
    Loglevel = :error
  end

  begin
    # configure logging
    Logging.color_scheme( 'bright',
      :levels => {
        :debug => :grey,
        :info  => :green,
        :warn  => :orange,
        :error => :red,
        :fatal => [:white, :on_red]
      },
      :date => :blue,
      :logger => :cyan,
      :message => :yellow
    )

    Logging.appenders.stderr(
      'stderr',
      :layout => Logging.layouts.pattern(
        :pattern => '[%d] %-5l %c: %m\n',
        :color_scheme => 'bright'
      )
    )

    $log = Logging.logger['surveymonkey']
    $log.add_appenders 'stderr'

    $log.level = Loglevel
    $log.debug("Configured logging to stderr.")
  rescue Exception => e
    $stderr.puts("Unable to configure logging: #{e.message}")
    raise
  end
end
