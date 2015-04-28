require "surveymonkey/version"

module Surveymonkey
  autoload :Config, 'surveymonkey/config'
  autoload :Client, 'surveymonkey/client'
  autoload :Logger, 'surveymonkey/logger'

  def config
    Surveymonkey::Config.new()
  end
end
