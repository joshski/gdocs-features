require 'rest_client'

class GoogleResource
  def initialize(auth, url, headers={})
    @auth, @url, @headers = auth, url, headers
  end

  def get(additional_headers={})
    RestClient.get @url, @headers.merge(additional_headers).merge("Authorization" => @auth.header)
  end
end
