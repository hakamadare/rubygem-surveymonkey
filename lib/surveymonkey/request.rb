require 'surveymonkey/logging'
require 'surveymonkey/api'
require 'surveymonkey/client'
require 'surveymonkey/error'

##
# Object representing a request to the SurveyMonkey API.  Parameters should all be populated automatically.

class Surveymonkey::Request

  begin
    attr_reader :api, :api_method, :client, :path, :api_key, :baseuri, :method_name
    attr_accessor :access_token, :method_params

    # constants

    Baseuri = 'https://api.surveymonkey.net'

    # public methods

    ##
    # Send the HTTP request to the SurveyMonkey API and parse the response.
    # This is an opportunity to override defaults, _e.g._ if you want to use
    # different credentials for a specific request, or if you're sending the
    # same request repeatedly with different parameters.

    def execute(method_params = self.method_params, api_method = self.api_method, api_key = self.api_key, access_token = self.access_token)
      begin
        $log.debug(sprintf("%s: enter", __method__))

        method_logname = sprintf("%s[%s]", __method__, api_method)

        self.method_params=(self.api.api_method_params(method_params))
        method_params = self.method_params
        $log.debug(sprintf("%s: method_params: %s", method_logname, method_params))

        path = api_method.path
        $log.debug(sprintf("%s: path: %s", method_logname, path))

        http_method = api_method.http_method
        $log.debug(sprintf("%s: http_method: %s", method_logname, http_method))

        request_uri = _request_uri(path, api_key)
        $log.debug(sprintf("%s: ready to make request for '%s'", method_logname, api_method))

        response = self.client.class.send(http_method.to_sym, request_uri, body: self.method_params)

        $log.debug(sprintf("%s: response class %s code %i", method_logname, response.class, response.code))
        $log.debug(sprintf("%s: response headers '%s'", method_logname, response.headers.inspect))

        if _valid_response?(response)
          parsed = response.parsed_response
          status = parsed.fetch('status')
          $log.debug(sprintf("%s: API returned status %i", method_logname, status))

          if status == 0
            $log.debug(sprintf("%s: raw data: %s", method_logname, response.body.to_s))
            $log.debug(sprintf("%s: parsed data: %s", method_logname, parsed.fetch('data', []).inspect))
            parsed
          else
            raise Surveymonkey::Error.new(parsed)
          end

        else
          $log.error sprintf("%s: API returned invalid HTTP response code from '%s'", method_logname, self)

          mashery_error_code  = $response.headers.fetch('x-mashery-error-code', 'UNKNOWN')
          error_detail_header = $response.headers.fetch('x-error-detail-header', 'Unknown')

          the_error = {
            'status' => 3,
            'errmsg' => sprintf("%s (%s)", mashery_error_code, error_detail_header)
          }
          raise Surveymonkey::Error.new(the_error)
        end

      rescue StandardError => e
        $log.error sprintf("%s: unable to execute API request: %s", method_logname, self)
        $log.debug sprintf("%s: response: %s", method_logname, parsed.inspect)
        raise e
      end
    end

    ##
    # Create a new Surveymonkey::Request object.  Takes a string representing the API method name and a hash of parameters; the relevant parameters are the following:
    #
    # * baseuri
    # * method_params
    # * access_token
    # * api_key

    def initialize(api_method, *args)
      begin
        $log.debug(sprintf("%s: enter", __method__))
        $log.debug(sprintf("%s: api_method: %s", __method__, api_method))
        $log.debug(sprintf("%s: args: %s", __method__, args))

        # store the API method name for stringification
        @method_name = api_method

        api = Surveymonkey::API.new
        @api_method = api.api_method(api_method)

        # extract optional params
        param_hash = Hash.try_convert(args.shift) || {}
        @baseuri       = param_hash.fetch('baseuri', Baseuri)
        @method_params = api.api_method_params(param_hash.fetch('method_params', {}))
        @access_token  = param_hash.fetch('access_token', _from_env('SURVEYMONKEY_ACCESSTOKEN'))
        @api_key       = param_hash.fetch('api_key', _from_env('SURVEYMONKEY_APIKEY'))

        # configure the client
        @client = Surveymonkey::Client.new(baseuri = @baseuri, access_token = @access_token, api_key = @api_key)

        # configure the API
        @api = Surveymonkey::API.new

      rescue StandardError => e
        $log.error(sprintf("%s: unable to initialize API request: %s", __method__, e.message))
        raise
      end
    end

    ##
    # Stringify a Surveymonkey::Request object
    #

    def to_s
      sprintf("%s %s", self.api_method, self.method_params.inspect)
    end


    # private methods
    private

    def _client #:nodoc:
      begin
        @client = Surveymonkey::Client.new()
      rescue StandardError => e
        $log.fatal(sprintf("%s: %s", "Unable to initialize REST client", e.message))
        $log.debug(sprintf("%s: %s", __method__, e))
        raise
      end
    end

    def _api #:nodoc:
      begin
        @api = Surveymonkey::API.new()
      rescue StandardError => e
        $log.fatal(sprintf("%s: %s", "Unable to initialize SurveyMonkey API", e.message))
        $log.debug(sprintf("%s: %s", __method__, e))
        raise
      end
    end

    def _http_headers(token) #:nodoc:
      begin
        $log.debug(sprintf("%s: constructing http headers with token '%s'", __method__, token))
        http_headers = {
          "Content-Type" => "application/json",
          "Authorization" => sprintf("bearer %s", token),
        }
        $log.debug(sprintf("%s: http headers: '%s'", __method__, http_headers))
        http_headers

      rescue StandardError => e
        $log.error(sprintf("%s: %s", __method__, e.message))
        raise e
      end
    end

    def _from_env(key) #:nodoc:
      begin
        $log.debug(sprintf("%s: fetching '%s' from environment", __method__, key))
        value = ENV.fetch(key)
        $log.debug(sprintf("%s: retrieved '%s'", __method__, value))
        value

      rescue KeyError => e
        $log.info(sprintf("%s: '%s' not found in environment", __method__, key))
      rescue StandardError => e
        $log.error(sprintf("%s: %s", __method__, e.message))
        raise e
      end
    end

    def _request_uri(path, api_key) #:nodoc:
      begin
        $log.debug(sprintf("%s: generating request uri fragment from '%s' and '%s'", __method__, path, api_key))
        request_uri = sprintf("%s?api_key=%s", path, api_key)
        $log.debug(sprintf("%s: generated '%s'", __method__, request_uri))
        request_uri

      rescue StandardError => e
        $log.error(sprintf("%s: %s", __method__, e.message))
        raise e
      end
    end

    def _valid_response?(response) #:nodoc:
      begin
        code = response.code
        $log.debug sprintf("%s: HTTP response code is %i", __method__, code)
        # this claims to raise an exception if the response is not a 2XX
        response.value

        code

      rescue Net::HTTPError => e
        $log.error sprintf("%s: HTTP error: %s", __method__, e.message)
        return nil

      rescue StandardError => e
        $log.error(sprintf("%s: %s", __method__, e.message))
        raise e
      end
    end
  end
end
