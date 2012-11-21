require 'spec_helper'
require 'oauth2'

describe Doorkeeper do
  let(:application) {Doorkeeper::Application.create(name: 'test',redirect_uri:'urn:ietf:wg:oauth:2.0:oob')}
  let(:user){ User.create(email:'user@example.com',password:'sekret',username:'tester')}
  let(:client){ 
    OAuth2::Client.new(application.uid, application.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
  }

  it 'authorize_url should include uid' do


    #site          = "http://localhost:3000" # your provider server, mine is running on localhost

    url = client.auth_code.authorize_url(:redirect_uri => application.redirect_uri)
    url.should include "client_id=#{application.uid}"
  end

  it 'get token by email and password' do 
    access_token = client.password.get_token('user@example.com', 'sekret',{username:'user@example.com', password:'sekret'})
    access_token.should_not be_expired
  end
end



