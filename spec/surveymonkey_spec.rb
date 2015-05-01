require 'spec_helper'

describe Surveymonkey do
  it 'has a version number' do
    expect(Surveymonkey::VERSION).not_to be nil
  end
end

describe Surveymonkey::Client.new() do
  it { is_expected.to respond_to(:baseuri) }
  it { is_expected.to respond_to(:access_token) }
  it { is_expected.to respond_to(:api_key) }
  it { is_expected.to respond_to(:api_call) }

  it 'has the correct default URL' do
    expect(Surveymonkey::Client.new().baseuri).to match('https://api.surveymonkey.net')
  end
end
