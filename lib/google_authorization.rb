require 'rest_client'

class GoogleAuthorization

  def initialize(email, password)
    @email, @password = email, password
  end

  def header
    @header ||= "GoogleLogin auth=#{authorize}"
  end

  def authorize
    params = { "accountType" => "HOSTED_OR_GOOGLE", "Email" => @email, "Passwd" => @password, "service" => "writely" }
    result = RestClient.post "https://www.google.com/accounts/ClientLogin", params
    result.to_s[/Auth=(.*)/, 1]
  end
end
