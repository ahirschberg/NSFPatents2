require_relative 'spec_helper'

describe RangeHelper do
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
