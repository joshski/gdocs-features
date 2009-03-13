require 'nokogiri'
require 'google_feature'

class GoogleFeatureStore
  PARENT_FOLDER_REL = "http://schemas.google.com/docs/2007#parent"
  
  def initialize(client)
    @client = client
  end

  def features
    feed = @client.documents_feed.get.to_s
    folder_map = folders
    Nokogiri::HTML(feed).css("entry").map do | entry |
      parent_links = entry.xpath("link[@rel='#{PARENT_FOLDER_REL}']/@href")
      href = parent_links.first.text.to_s
      folder = folder_map[href]
      GoogleFeature.new(@client, entry, folder)
    end
  end

  def folders
    feed = @client.folders.get.to_s
    doc = Nokogiri::HTML(feed)
    map = {}
    doc.css("entry").each do | entry |
      map[entry.css("id").text] = folder_path(doc, entry)
    end
    map
  end

  def folder_path(doc, entry)
    title = entry.css("title").text
    parent = parent_folder_entry(doc, entry)
    ((parent ? folder_path(doc, parent) : '') + '/' + title).gsub(/^\//, '')
  end

  def parent_folder_entry(doc, entry)
    parent_link = entry.css("link[rel='#{PARENT_FOLDER_REL}']").first
    return nil if parent_link.nil?
    doc.xpath("//entry[id='#{parent_link.attributes['href']}']").first
  end
end

