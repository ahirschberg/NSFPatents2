require_relative 'util'

class FileGetter
  def self.download_file(target_dir, uri_string)
    filepath = "#{target_dir}/#{get_filename_from_url uri_string}"
    uri = URI(uri_string)
    File.open filepath, 'w' do |file|
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.request_get uri.path do |response|
          response.read_body {|segment| file.write segment}
        end
      end
    end
    filepath 
  end

  private
  def self.get_filename_from_url(url)
    url[url.rindex("/")+1..url.size]
  end
end
