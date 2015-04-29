$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# set API credentials in env
ENV['SURVEYMONKEY_APIKEY']      = 'aaaaaabbbbbbccccccdddddd'
ENV['SURVEYMONKEY_ACCESSTOKEN'] = 'aaaaaabbbbbbccccccddddddaaaaaabbbbbbccccccddddddaaaaaabbbbbbccccccddddddaaaaaabbbbbbccccccddddddaaaaaabbbbbbccccccddddddaaaaaabbbbbb'

require 'surveymonkey'
