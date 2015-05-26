require "deep_merge"
require "logging"

require "surveymonkey/version"
require "surveymonkey/logging"
require "surveymonkey/error"
require "surveymonkey/request"
require "surveymonkey/datestring"

##
# Top-level module, holds the user-facing methods

module Surveymonkey

  class << self
    # Constants

    ##
    # Default page size for paginated API requests

    DefaultPageSize = 1000

    ##
    # API methods that support pagination

    PaginatedMethods = {
      :get_survey_list     => 'surveys',
      :get_collector_list  => 'collectors',
      :get_respondent_list => 'respondents',
      :get_template_list   => 'templates',
    }

    # Public methods

    ##
    # Catch-all method; matches SurveyMonkey API method names.  Call like so:
    #  
    #  Surveymonkey.get_user_details({'method_params' => {'foo' => 'bar'}})

    def method_missing(method_name, *args)
      begin
        $log.debug sprintf("%s: %s", __method__, 'enter')

        the_args = Hash(Array(args).shift) || {}

        # extract page_size if passed in args
        page_size = the_args.delete('page_size') { |key| DefaultPageSize }.to_i
        $log.debug sprintf("%s: page_size: %i", __method__, page_size)

        method_params = parse_datestrings(the_args)
        $log.debug sprintf("%s: method_params: %s", __method__, method_params.inspect)

        # is this a paginated method?
        pagination_field = PaginatedMethods.fetch(method_name, nil)
        if pagination_field
          $log.info sprintf("calling method '%s' with pagination, page size %i", method_name, page_size)
          paginate_request(method_name, pagination_field, page_size, method_params)
        else
          $log.info sprintf("calling method '%s' without pagination", method_name)
          Surveymonkey::Request.new(method_name.to_s, method_params).execute
        end

      rescue TypeError => e
        $log.fatal sprintf("%s: method parameters must be a hash", __method__)
        exit 1

      rescue KeyError => e
        $log.fatal sprintf("%s: method '%s' not implemented", __method__, method_name.to_s)
        exit 1

      rescue StandardError => e
        $log.error sprintf("%s: %s", __method__, e.message)
        raise e

      end
    end

    # Private methods
    private

    ##
    # Execute a series of requests, collating the results.

    def paginate_request(api_method, field, page_size = 1000, method_params = {}) # :nodoc:
      begin
        $log.debug sprintf("%s: enter", __method__)

        current_page = 1
        num_results = page_size
        final_response = {}
        results = []

        $log.info sprintf("%s: requesting pages of %i items", __method__, page_size)

        while num_results >= page_size

          method_params.merge!({'page' => current_page})
          method_params.merge!({'page_size' => page_size})

          $log.debug sprintf("requesting %s: %s", api_method, method_params.inspect)

          response = execute_request(api_method.to_sym, method_params)

          page_results = response.fetch('data', {}).fetch(field, [])

          $log.info sprintf("%s returned batch of %i results", api_method, page_results.length)

          results.concat(page_results)

          $log.info sprintf("%i total results collected from %s", results.length, api_method)

          num_results = page_results.length

          current_page = current_page.next

          final_response.deep_merge!(response)
        end

        final_response['data'].store(field, results.uniq)

        final_response

      rescue Surveymonkey::Error => e
        $log.error sprintf("SurveyMonkey API error: %s", e.message)
        raise e

      rescue StandardError => e
        $log.error(sprintf("%s: %s", __method__, e.message))
        raise e

      end
    end

    ##
    # Parse and validate DateStrings in method parameters
    def parse_datestrings(method_params = {}) # :nodoc:
      begin
        ['start_date', 'end_date'].each do |date_param|
          if method_params.has_key?(date_param)
            raw = method_params.fetch(date_param)
            $log.debug(sprintf("%s: parsing '%s' as %s param", __method__, raw, date_param))

            parsed = Surveymonkey::DateString.new(raw).to_s
            $log.debug(sprintf("%s: parsed '%s' to '%s'", __method__, raw, parsed))

            method_params.store(date_param, parsed)
          end
        end

        method_params

      rescue StandardError => e
        $log.error(sprintf("%s: %s", __method__, e.message))
        raise e

      end
    end

    ##
    # Execute a single API request.
    def execute_request(method_name, method_params = {}) # :nodoc:
      begin
        $log.debug sprintf("%s: %s %s", __method__, method_name.to_s, method_params.inspect)

        Surveymonkey::Request.new(method_name.to_s, {'method_params' => method_params}).execute

      rescue StandardError => e
        $log.error sprintf("%s: %s", __method__, e.message)
        raise e

      end
    end

  end
end
