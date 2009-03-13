require 'feature'

class GoogleFeature < Feature

  def initialize(client, entry, folder)
    @client, @entry, @folder = client, entry, folder
  end

  def title
    underscore(camelize(@entry.css("title")[0].text))
  end

  def version
    @version ||= @entry.css("updated")[0].text
  end

  def body
    @body ||= remove_html(download_body).map {|line| line.strip}.reject { |l| l == "" }
  end

  def body_url
    @entry.css("content").first.attributes["src"].value.gsub("justBody=false", "justBody=true")
  end

  def path
    "#{@folder}/#{title}.feature"
  end

  def download_body
    @client.document_body(body_url).get.to_s
  end

  def remove_html(html_body)
    html_body.gsub("&nbsp;", " ").gsub("<br>", "\n").gsub("\n\n", "\n").gsub(/<\/?[^>]*>/, "")
  end

  def underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end

  def camelize(lower_case_and_underscored_word)
    lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
  end

end