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

  it { is_expected.to respond_to(:get) }
  it { is_expected.to respond_to(:put) }
  it { is_expected.to respond_to(:post) }
  it { is_expected.to respond_to(:delete) }
end

describe Surveymonkey::Client.new() do
  it { is_expected.to respond_to(:url) }

  it 'has the correct default URL' do
    expect(Surveymonkey::Client.new.url).to be_kind_of(URI)
    expect(Surveymonkey::Client.new.url.to_s).to match('https://api.surveymonkey.net/v2')
  end
end
