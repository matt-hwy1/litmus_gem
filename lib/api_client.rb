require 'net/http'

class ApiClient

  attr_reader :api_url, :api_token

  def initialize(options)
    @api_url = options[:api_url]
    @api_token = options[:api_token]
  end

  def get_status_code
    uri = URI(@api_url)
    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/json"
    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    response.body
  end

  # Set the message and status code.
  def set_app_status(options = {})
    uri = URI(@api_url)
    request = Net::HTTP::Post.new(uri)
    request.set_form_data( options )
    request["AUTHORIZATION"] = "Token token=#{@api_token}" # Redundant since all #create requests in the API controller are JSON.
    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    response.body
  end

end