require 'spec_helper'

describe Surveymonkey do
  it 'has a version number' do
    expect(Surveymonkey::VERSION).not_to be nil
  end
end

baseuri      = 'https://api.surveymonkey.net'
access_token = 'accesstokenaccesstoken'
api_key      = 'apikeyapikey'
describe Surveymonkey::Client.new(baseuri, 'accesstokenaccesstoken', 'apikeyapikey') do
  it { is_expected.to respond_to(:baseuri) }
  it { is_expected.to respond_to(:access_token) }
  it { is_expected.to respond_to(:api_key) }

  it 'has the correct base URL' do
    expect(Surveymonkey::Client.new(baseuri, 'accesstokenaccesstoken', 'apikeyapikey').baseuri).to match(baseuri)
  end

  it 'has the correct access token' do
    expect(Surveymonkey::Client.new(baseuri, 'accesstokenaccesstoken', 'apikeyapikey').access_token).to match(access_token)
  end

  it 'has the correct API key' do
    expect(Surveymonkey::Client.new(baseuri, 'accesstokenaccesstoken', 'apikeyapikey').api_key).to match(api_key)
  end
end

describe Surveymonkey::API.new() do
  it { is_expected.to be_an_instance_of(Surveymonkey::API) }
  it { is_expected.to respond_to(:api_method) }
  it { is_expected.to respond_to(:api_method_params) }
end

describe Surveymonkey::Request.new('get_survey_list') do
  it { is_expected.to be_an_instance_of(Surveymonkey::Request) }

  it { is_expected.to respond_to(:api) }
  it { is_expected.to respond_to(:api_key) }
  it { is_expected.to respond_to(:api_method) }
  it { is_expected.to respond_to(:baseuri) }
  it { is_expected.to respond_to(:client) }
  it { is_expected.to respond_to(:method_params) }
end

describe Surveymonkey::API.new().api_method('get_survey_list') do
  it { is_expected.to be_an_instance_of(Surveymonkey::API::Method) }
end
