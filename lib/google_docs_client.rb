require 'google_authorization'
require 'google_resource'

class GoogleDocsClient
  def initialize(email, password)
    @auth = GoogleAuthorization.new(email, password)
  end

  def documents_feed
    GoogleResource.new(@auth, "http://docs.google.com/feeds/documents/private/full", :accept => "application/atom+xml")
  end

  def document_body(uri)
    GoogleResource.new(@auth, uri, :accept => "text/html")
  end

  def folders
    GoogleResource.new(@auth, "http://docs.google.com/feeds/documents/private/full/-/folder?showfolders=true", :accept => "application/atom+xml")
  end
end
