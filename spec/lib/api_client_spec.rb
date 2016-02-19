require 'spec_helper'
require 'api_client'

RSpec.describe ApiClient do
  it "should be able to GET the status code from the endpoint URL" do
    result_message = "{\"success\":{\"running\":true,\"message\":\"The app is up!\"}}"

    stub_request(:get, "http://localhost:3000/").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                          'Host'=>'localhost:3000', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => result_message, :headers => {})

    client = ApiClient.new(api_url: "http://localhost:3000")
    expect( client.get_status_code ).to eq result_message
  end

  it "should be able to POST the status code and message to the endpoint URL" do
    result_message = "{\"success\":{\"running\":true,\"message\":\"The app is up!\"}}"

    stub_post_request("aaaa1111").to_return(:status => 200, :body => result_message, :headers => {})

    client = ApiClient.new(api_url: "http://localhost:3000/app_statuses", api_token: "aaaa1111")
    expect( client.set_app_status(message: "The app is up!", running: 1) ).to eq result_message
  end

  it "should not be able to POST the status code and message without a tokenL" do
    result_message = "HTTP Token: Access denied.\n"

    stub_post_request(nil).to_return(:status => 200, :body => result_message, :headers => {})

    client = ApiClient.new(api_url: "http://localhost:3000/app_statuses")
    expect( client.set_app_status(message: "The app is up!", running: 1) ).to eq result_message
  end

  it "should properly set the api_url" do
    url = "http://localhost:3000/app_statuses"
    client = ApiClient.new(api_url: url)
    expect(client.api_url).to eq url
  end

  it "should properly set the api_token" do
    token = "abcde"
    client = ApiClient.new(api_token: token)
    expect(client.api_token).to eq token
  end

  def stub_post_request(token)
    stub_request(:post, "http://localhost:3000/app_statuses").
        with(:body => {"message"=>"The app is up!", "running"=>"1"},
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                          'Authorization'=>"Token token=#{token}", 'Content-Type'=>'application/x-www-form-urlencoded',
                          'Host'=>'localhost:3000', 'User-Agent'=>'Ruby'})
  end
end
