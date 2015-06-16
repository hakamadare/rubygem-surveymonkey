require 'surveymonkey/logging'

class Surveymonkey::Error < StandardError
  # constants

  ##
  # API status codes, documented upstream.

  Status_codes = {
    0 => 'Success',
    1 => 'Not Authenticated',
    2 => 'Invalid User Credentials',
    3 => 'Invalid Request',
    4 => 'Unknown User',
    5 => 'System Error'
  }

  attr_reader :status, :status_name, :status_codes, :errmsg

  ##
  # Create a new Surveymonkey::Error object.  Pass in the hash parsed from the
  # JSON object returned by the API.

  def initialize(error = {}, status_codes = Status_codes)
    begin
      @status_codes = status_codes
      @status       = error.fetch('status', 0)
      @errmsg       = error.fetch('errmsg', '')
      @status_name  = _status_name(@status)

    rescue StandardError => e
      $log.error(sprintf("%s: unable to parse '%s' as error", __method__, error.inspect))
      raise e
    end
  end

  ##
  # Stringify a Surveymonkey::Error object.

  def to_s
    sprintf("Error %i (%s): %s", self.status, self.status_name, self.errmsg)
  end

  private

  def _status_name(error) # :nodoc:
    begin
      self.status_codes.fetch(error)
    rescue StandardError => e
      $log.error(sprintf("%s: %i is not a valid error code", __method__, error))
      raise
    end
  end
end
