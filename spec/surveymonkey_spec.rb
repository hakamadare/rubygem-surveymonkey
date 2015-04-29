require 'spec_helper'

describe Surveymonkey do
  it 'has a version number' do
    expect(Surveymonkey::VERSION).not_to be nil
  end
end

describe Surveymonkey::Client do
  it 'is a RestClient' do
    expect(Surveymonkey::Client).to be_kind_of(RestClient)
  end
end

describe Surveymonkey::Client.new(apikey = ENV['SURVEYMONKEY_APIKEY'], accesstoken = ENV['SURVEYMONKEY_ACCESSTOKEN']) do
  it { is_expected.to respond_to(:url) }
  it { is_expected.to respond_to(:apikey) }
  it { is_expected.to respond_to(:accesstoken) }

  it 'has the correct default URL' do
    expect(Surveymonkey::Client.new(apikey = ENV['SURVEYMONKEY_APIKEY'], accesstoken = ENV['SURVEYMONKEY_ACCESSTOKEN']).url).to be_kind_of(URI)
    expect(Surveymonkey::Client.new(apikey = ENV['SURVEYMONKEY_APIKEY'], accesstoken = ENV['SURVEYMONKEY_ACCESSTOKEN']).url.to_s).to match('https://api.surveymonkey.net/v2')
  end
end
