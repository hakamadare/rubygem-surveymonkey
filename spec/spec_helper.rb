$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# set API credentials in env
ENV['SURVEYMONKEY_APIKEY'] = 'aaaaaabbbbbbccccccdddddd' unless ENV.member?('SURVEYMONKEY_APIKEY')
ENV['SURVEYMONKEY_ACCESSTOKEN'] = 'aaaaaabbbbbbccccccddddddaaaaaabbbbbbccccccddddddaaaaaabbbbbbccccccddddddaaaaaabbbbbbccccccddddddaaaaaabbbbbbccccccddddddaaaaaabbbbbb' unless ENV.member?('SURVEYMONKEY_ACCESSTOKEN')

require 'surveymonkey'
require 'pry'
