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
