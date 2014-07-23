$BASE_FILE_PATH = File.expand_path(File.dirname(__FILE__) + "/..").freeze # path to base directory
$DL_PATH        = $BASE_FILE_PATH + "/dl"
$TEMP_PATH      = $BASE_FILE_PATH + "/temp"

class FilenameExtractor
  def self.extract_from_string(string)
    File.basename(string).sub /(?:\.\w+)?\z/, ''
  end
end
