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

describe RangeHelper do
  describe "#expand_range" do
    context "takes url, startdate, enddate, and prefix arguments" do
      it "returns all filenames between start and end dates" do
        VCR.use_cassette('grants_page') do
          filenames = RangeHelper.expand_range url: "http://localhost:9090/grant_page/grant_page.html", startdate: "01-01-13", enddate: "01-15-13", prefix: "ipg"
          expect(filenames).to eq(["ipg130101", "ipg130108", "ipg130115"])
        end
      end
    end
  end

  describe RangeHelper::RangeWebParser do
    
    let(:rwp) {RangeHelper::RangeWebParser}

    describe "#get_webpage_and_parse" do
      it "requests url and scrapes response for patent file links" do
        VCR.use_cassette('grants_page') do
          links = rwp.get_webpage_and_parse "http://localhost:9090/grant_page/grant_page.html"
          expect(links).to include(
            "http://storage.googleapis.com/patents/grant_full_text/2013/ipg130101.zip", 
            "http://storage.googleapis.com/patents/grant_full_text/2013/ipg130108.zip", 
            "http://storage.googleapis.com/patents/grant_full_text/2013/ipg130115.zip")
        end
      end
    end
  end
end

describe RunTemplate do

  let(:rt) { RunTemplate.new }
  grant_script_hash = {patent_prefix: "ipg", page_url: "http://localhost:9090/grant_page/grant_page.html"}
  describe "#run" do
    it "takes arguments and expands them into filenames" do
      VCR.use_cassette('grants_page') do
        rt.run(%w[ipg123456, 01-01-13 to 01-20-13], grant_script_hash)
        expect(rt.selected_filenames).to contain_exactly("ipg123456", "ipg130101", "ipg130108", "ipg130115")
      end
    end

    context "bad command line arguments passed in" do
      it "logs to STDERR" do
        expect{rt.run(["garbage_command"], grant_script_hash)}.to output(/garbage_command/).to_stderr
      end
    end
  end
end
