require 'net/http'
require 'nokogiri'

# Helper classes
require_relative './exceptions'
require_relative './util'

# Module classes
require_relative './range_web_parser'
require_relative './range_formatter'
require_relative './range_selector'

module RangeHelper
  def self.expand_range(args)
    links = RangeWebParser.get_webpage_and_parse args[:url]
    std_start, std_end = RangeFormatStandardizer.standardize_range_formats args[:startdate], args[:enddate]
    selected_links = RangeSelector.select_between startdate: std_start, enddate: std_end, prefix: args[:prefix], links: links
    selected_links.map {|link| FilenameExtractor.extract_from_string link}
  end
end

if __FILE__ == $0
  filenames = RangeHelper::RangeFormatStandardizer.standardize_range_formats "01-01-14ddd", "0qqq1-15-14"
  puts filenames
end
