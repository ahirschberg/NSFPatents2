require_relative 'spec_helper'

describe FileGetter do

  before(:each) do
    Dir.mkdir $TEMP_PATH unless Dir.exist? $TEMP_PATH
  end 

  describe "#download_file" do
    it "downloads a file from a url" do
      VCR.use_cassette(:example_zip) do
        web_file_path = FileGetter.download_file($TEMP_PATH, "http://localhost:9090/zip/example.zip") 
        web_file = File.open web_file_path, 'r'
        local_file = File.open($BASE_FILE_PATH + "/spec/fixtures/zip/example.zip", 'r')
        expect(web_file.read).to eq(local_file.read) # Is there a better way?
      end
    end
  end
end
