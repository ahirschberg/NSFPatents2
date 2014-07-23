describe RangeHelper do
  describe RangeHelper::RangeWebParser do
    
    let(:rwp) {RangeHelper::RangeWebParser}

    describe "#get_webpage_and_parse" do
      it "requests url and scrapes response for patent file links" do
        VCR.use_cassette('grants_page') do
          links = rwp.get_webpage_and_parse "http://www.google.com/googlebooks/uspto-patents-grants-text.html"
          expect(links).to include(
            "http://storage.googleapis.com/patents/grant_full_text/2014/ipg140225.zip", 
            "http://storage.googleapis.com/patents/grant_full_text/2014/ipg140304.zip", 
            "http://storage.googleapis.com/patents/grant_full_text/2014/ipg140311.zip")
        end
      end
    end
  end
end
