require 'surveymonkey/logging'
require 'json'

##
# Object representing the SurveyMonkey API.

class Surveymonkey::API
  autoload :Method, 'surveymonkey/api/method'

  # constants

  ##
  # String indicated the version of the SurveyMonkey API implemented.

  Api_version = 'v2'

  ##
  # Hash defining the methods in the SurveyMonkey API.  Current as of 2015-12-14.

  Api_methods = {
    'create_flow' => {
      'path' => '/v2/batch/create_flow',
    },
    'send_flow' => {
      'path' => '/v2/batch/send_flow',
    },
    'create_collector' => {
      'path' => '/v2/collectors/create_collector',
    },
    'get_survey_list' => {
      'path' => '/v2/surveys/get_survey_list',
    },
    'get_survey_details' => {
      'path' => '/v2/surveys/get_survey_details',
    },
    'get_collector_list' => {
      'path' => '/v2/surveys/get_collector_list',
    },
    'get_respondent_list' => {
      'path' => '/v2/surveys/get_respondent_list',
    },
    'get_responses' => {
      'path' => '/v2/surveys/get_responses',
    },
    'get_response_counts' => {
      'path' => '/v2/surveys/get_response_counts',
    },
    'get_template_list' => {
      'path' => '/v2/templates/get_template_list',
    },
    'get_user_details' => {
      'path' => '/v2/user/get_user_details',
    },
    'create_recipients' => {
      'path' => '/v2/collectors/create_recipients',
    },
  }

  # public methods
  attr_reader :api_methods, :api_version

  ##
  # Look up a SurveyMonkey API method and return its path and associated HTTP method.

  def api_method(key, api_methods = self.api_methods)
    begin
      $log.debug(sprintf("%s: api methods: %s", __method__, api_methods.inspect))
      $log.debug(sprintf("%s: fetching '%s' from API methods", __method__, key))
      value = api_methods.fetch(key)
      $log.debug(sprintf("%s: retrieved '%s'", __method__, value.inspect))

      path = value['path']
      $log.debug(sprintf("%s: path '%s'", __method__, path))
      method = (value['method'] || 'post')
      $log.debug(sprintf("%s: method '%s'", __method__, method))

      # return
      Surveymonkey::API::Method.new(path, method, method_name = key)

    rescue KeyError => e
      $log.error(sprintf("%s: '%s' not found in api methods", __method__, key))
      raise e
    rescue StandardError => e
      $log.error(sprintf("%s: %s", __method__, e.message))
      raise
    end
  end

  ##
  # SurveyMonkey API method params need to be a JSON-encoded string; this
  # method passes through a string and tries to turn another data type into
  # JSON.

  def api_method_params(method_params)
    begin
      # TODO validate params against API spec
      $log.debug(sprintf("%s: parsing api method params from '%s'", __method__, method_params))
      the_params = (method_params.kind_of?(String) ? method_params : JSON.generate(method_params || {}))
      $log.debug(sprintf("%s: parsed method params '%s'", __method__, the_params))

      # return
      the_params

    rescue StandardError => e
      $log.error(sprintf("%s: %s", __method__, e.message))
      raise
    end
  end

  ##
  # Create a new Surveymonkey::API object.  The only parameter is an
  # api_methods hash (use this if you want to override the definition of the
  # SurveyMonkey API, I guess?)

  def initialize
    begin
      @api_methods = Api_methods
      @api_version = Api_version
    rescue StandardError => e
      $log.error(sprintf("%s: %s", __method__, e.message))
      raise
    end
  end

  ##
  # Stringify a Surveymonkey::API object.

  def to_s
    self.api_version
  end

end
