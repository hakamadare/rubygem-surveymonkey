require 'spec_helper'

describe Surveymonkey do
  it 'has a version number' do
    expect(Surveymonkey::VERSION).not_to be nil
  end
end

describe Surveymonkey::Logger do
  it 'is a Log4r' do
    expect(Surveymonkey::Logger).to be_kind_of(Log4r)
  end
end
describe Surveymonkey::Client do
  it 'is a RestClient' do
    expect(Surveymonkey::Client).to be_kind_of(RestClient)
  end
end