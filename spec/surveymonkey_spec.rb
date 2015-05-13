require 'spec_helper'

describe Surveymonkey do
  it 'has a version number' do
    expect(Surveymonkey::VERSION).not_to be nil
  end
end

baseuri      = 'https://api.surveymonkey.net'
access_token = 'accesstokenaccesstoken'
api_key      = 'apikeyapikey'
error_hash   = {'status' => 2, 'errmsg' => 'Oh noes access denied'}

describe Surveymonkey::Client.new(baseuri, 'accesstokenaccesstoken', 'apikeyapikey') do
  it { is_expected.to be_an_instance_of(Surveymonkey::Client) }
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

describe Surveymonkey::Client.new(baseuri, 'accesstokenaccesstoken', 'apikeyapikey').to_s do
  it { is_expected.to be_a_kind_of(String) }
  it { is_expected.to eq(baseuri) }
end

describe Surveymonkey::API.new() do
  it { is_expected.to be_an_instance_of(Surveymonkey::API) }
  it { is_expected.to respond_to(:api_method) }
  it { is_expected.to respond_to(:api_version) }
  it { is_expected.to respond_to(:api_method_params) }
end

describe Surveymonkey::API.new().to_s do
  it { is_expected.to be_a_kind_of(String) }
  it { is_expected.to eq('v2') }
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

describe Surveymonkey::Request.new('get_survey_list').to_s do
  it { is_expected.to be_a_kind_of(String) }
  it { is_expected.to eq('get_survey_list') }
end

describe Surveymonkey::API.new().api_method('get_survey_list') do
  it { is_expected.to be_an_instance_of(Surveymonkey::API::Method) }
end

describe Surveymonkey::API.new().api_method('get_survey_list').to_s do
  it { is_expected.to be_a_kind_of(String) }
  it { is_expected.to eq('get_survey_list') }
end

describe Surveymonkey::Error.new() do
  it { is_expected.to be_an_instance_of(Surveymonkey::Error) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:status_name) }
  it { is_expected.to respond_to(:errmsg) }
end

describe Surveymonkey::Error.new(error_hash) do
  it { is_expected.to be_an_instance_of(Surveymonkey::Error) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:status_name) }
  it { is_expected.to respond_to(:errmsg) }
end
