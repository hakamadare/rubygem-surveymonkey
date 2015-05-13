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
        $log.debug(sprintf("%s: enter\n", __method__))

        self.method_params=(self.api.api_method_params(method_params))
        method_params = self.method_params
        $log.debug(sprintf("%s: method_params: %s\n", __method__, method_params))

        path = api_method.path
        $log.debug(sprintf("%s: path: %s\n", __method__, path))

        http_method = api_method.http_method
        $log.debug(sprintf("%s: http_method: %s\n", __method__, http_method))

        request_uri = _request_uri(path, api_key)
        $log.debug(sprintf("%s: ready to make request for '%s'\n", __method__, api_method))

        response = self.client.class.send(http_method.to_sym, request_uri, body: self.method_params)

        $log.debug(sprintf("%s: response class %s\n", __method__, response.class))
        $log.debug(sprintf("%s: response code %i\n", __method__, response.code))
        $log.debug(sprintf("%s: response headers '%s'\n", __method__, response.headers.inspect))

        parsed = response.parsed_response
        status = parsed.fetch('status')

        if status == 0
          parsed
        else
          $log.debug(sprintf("%s: API returned status %i\n", __method__, status))
          raise Surveymonkey::Error.new(parsed)
        end

      rescue StandardError => e
        $log.error(sprintf("%s: unable to execute API request: %s\n", __method__, e.message))
        raise
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
        $log.debug(sprintf("%s: enter\n", __method__))
        $log.debug(sprintf("%s: api_method: %s\n", __method__, api_method))
        $log.debug(sprintf("%s: args: %s\n", __method__, args))

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
        $log.error(sprintf("%s: unable to initialize API request: %s\n", __method__, e.message))
        raise
      end
    end

    ##
    # Stringify a Surveymonkey::Request object
    #

    def to_s
      self.method_name
    end


    # private methods
    private

    def _client #:nodoc:
      begin
        @client = Surveymonkey::Client.new()
      rescue StandardError => e
        $log.fatal(sprintf("%s: %s\n", "Unable to initialize REST client", e.message))
        $log.debug(sprintf("%s: %s\n", __method__, e.message))
        raise
      end
    end

    def _api #:nodoc:
      begin
        @api = Surveymonkey::API.new()
      rescue StandardError => e
        $log.fatal(sprintf("%s: %s\n", "Unable to initialize SurveyMonkey API", e.message))
        $log.debug(sprintf("%s: %s\n", __method__, e.message))
        raise
      end
    end

    def _http_headers(token) #:nodoc:
      begin
        $log.debug(sprintf("%s: constructing http headers with token '%s'\n", __method__, token))
        http_headers = {
          "Content-Type" => "application/json",
          "Authorization" => sprintf("bearer %s", token),
        }
        $log.debug(sprintf("%s: http headers: '%s'\n", __method__, http_headers))
        http_headers

      rescue Exception => e
        $log.error(sprintf("%s: %s\n", __method__, e.message))
        raise
      end
    end

    def _from_env(key) #:nodoc:
      begin
        $log.debug(sprintf("%s: fetching '%s' from environment\n", __method__, key))
        value = ENV.fetch(key)
        $log.debug(sprintf("%s: retrieved '%s'\n", __method__, value))
        value

      rescue KeyError => e
        $log.info(sprintf("%s: '%s' not found in environment\n", __method__, key))
      rescue Exception => e
        $log.error(sprintf("%s: %s\n", __method__, e.message))
        raise
      end
    end

    def _request_uri(path, api_key) #:nodoc:
      begin
        $log.debug(sprintf("%s: generating request uri fragment from '%s' and '%s'\n", __method__, path, api_key))
        request_uri = sprintf("%s?api_key=%s", path, api_key)
        $log.debug(sprintf("%s: generated '%s'\n", __method__, request_uri))
        request_uri

      rescue StandardError => e
        $log.error(sprintf("%s: %s\n", __method__, e.message))
        raise
      end
    end
  end
end
