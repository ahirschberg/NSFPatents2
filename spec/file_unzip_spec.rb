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
        expected_output_path = "#{@args_hash[:fpath]}/#{File.basename(@args_hash[:zpath]).sub(/\.\w+$/, "")}.xml" #remove extension and add .xml

        expect(@filepath).to eq(expected_output_path)
      end
      it "correctly unzips the file" do
        file_text = File.open(@filepath, 'r').read
        expect(file_text).to match(/xml-example-file/)
      end
    end
  end
end
