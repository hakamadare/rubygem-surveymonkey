require "timeliness"

require "surveymonkey/logging"

module Surveymonkey
  class DateString
    attr_reader :raw
    attr_reader :time

    # SurveyMonkey DateStrings are always in UTC
    Timeliness.default_timezone = :utc

    # and have a specific format
    TimelinessFormat = 'yyyy-mm-dd hh:nn:ss'

    # but for stringification we have to use strftime format
    TimeFormat = '%Y-%m-%d %H:%M:%S'

    def to_s
      self.time.strftime(TimeFormat)
    end

    def <=>(other)
      self.time.<=>(other)
    end

    def initialize(datestring, args = {})
      begin
        $log.debug(sprintf("%s: parsing '%s'", __method__, datestring))

        @raw = datestring

        timeliness_args = { :format => TimelinessFormat }

        # merge additional args if provided
        begin
          timeliness_args.merge(args)
        rescue TypeError => e
          $log.error(sprintf("%s: '%s' (%s) is not a valid arguments hash", __method__, args.inspect, args.class))
        end

        parsed = Timeliness.parse(datestring, timeliness_args)

        if parsed.nil?
          # add a time component and try again
          $log.info(sprintf("%s: '%s' cannot be parsed as a datetime, adding a time component", __method__, datestring))
          datestring.concat(' 00:00:00')
          parsed = Timeliness.parse(datestring, timeliness_args)
        end

        if parsed.nil?
          raise StandardError, sprintf("'%s' is not a valid DateString", datestring)
        else
          @time = parsed
        end

      rescue StandardError => e
        $log.error(sprintf("%s: unable to parse '%s' as DateString", __method__, datestring))
        raise e
      end
    end
  end
end
