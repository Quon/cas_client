require File.dirname(__FILE__) + '/../spec_helper'

describe CasClient::Request do
  
  it 'returns login url' do
    request = CasClient::Request.new('http://example.com')
    request.login_url.should == URI.parse('http://localhost:3001/cas/login?service=http%3A%2F%2Fexample.com')
  end
  
  it 'returns logout url' do
    request = CasClient::Request.new('http://example.com')
    request.logout_url.should == URI.parse('http://localhost:3001/cas/logout')
  end
  
  it 'returns logout url with a destination' do
    request = CasClient::Request.new('http://example.com')
    request.logout_url('http://example.net').should == URI.parse('http://localhost:3001/cas/logout?destination=http%3A%2F%2Fexample.net')
  end
  
  it 'use ticket request parameter' do
    CasClient::Request.new('http://example.com', 'bar' => 'foo').should_not be_validable
    CasClient::Request.new('http://example.com', 'ticket' => 'foo').should be_validable
  end
  
end
