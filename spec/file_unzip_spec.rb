require_relative 'spec_helper'

describe FileUnzipper do
  describe "#unzip" do
    context "zip filepath and target filepath given" do
      
      before(:each) do
        @args_hash = { 
          zpath: $BASE_FILE_PATH + '/spec/fixtures/zip/example.zip', 
          fpath: $TEMP_PATH }

        @filepath = FileUnzipper.unzip(@args_hash)
      end

      it "creates file in target dir" do
        expected_output_path = "#{@args_hash[:fpath]}/#{FilenameExtractor.extract_from_string @args_hash[:zpath]}.xml" #remove extension and add .xml
        expect(@filepath).to eq(expected_output_path)
      end

      it "correctly unzips the file" do
        file_text = File.open(@filepath, 'r').read
        expect(file_text).to match(/xml-example-file/)
      end

      it "overwrites existing files" do
        File.delete(@filepath) if File.exists?(@filepath)
        File.open(@filepath, 'w') do |file|
          file.puts "should-be-overwritten"
        end
        
        new_filepath = FileUnzipper.unzip @args_hash
        file_text    = File.open(@filepath, 'r').read

        expect(new_filepath).to  eq(@filepath)
        expect(file_text).to     match(/xml-example-file/)
        expect(file_text).not_to match(/should-be-overwritten/)
      end
    end

    context "only zip path given" do
      it "raises an error" do
        expect{FileUnzipper.unzip zpath: $BASE_FILE_PATH + '/spec/fixtures/zip/example.zip'}.to raise_error(/nil/)
      end
    end
  end
end
