require 'zip'
require_relative 'util'

class FileUnzipper
  def self.unzip(args)
    raise StandardError, "Filepath cannot be nil" if args[:fpath].nil?
    
    Zip::File.open(args[:zpath]) do |zip_file|
      zip_file.each do |entry|
        if FilenameExtractor.extract_from_string(entry.name) == FilenameExtractor.extract_from_string(args[:zpath])

          #write to memory
          #content = entry.get_input_stream.read

          File.open("#{args[:fpath]}/#{entry.name}", "w") do |file|
            entry.extract(file){true}
            return file.path
          end
        end
      end
    end
  end
end
