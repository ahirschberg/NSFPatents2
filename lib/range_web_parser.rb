module RangeHelper
  class RangeWebParser
    def self.get_webpage_and_parse(url)
      parse_patent_links_from_html(get_webpage(url).body)
    end

    private
    def self.get_webpage(uri_string)
      uri = URI(uri_string)
      Net::HTTP.start uri.host do |http|
        http.request_get uri.path do |response|
          response
        end
      end
    end

    def self.parse_patent_links_from_html(html)
      document = Nokogiri::HTML(html)
      all_links = document.xpath '//a[@href]'
      all_links.map {|a| a["href"] if a["href"] =~ /ip[ag]\d{6}.zip/}.compact
    end
  end
end
