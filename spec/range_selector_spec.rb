describe RangeHelper do
  describe RangeHelper::RangeSelector do

    let(:rs) {RangeHelper::RangeSelector}

    describe "#select_between" do
      context "takes two dates with a collection of strings and selects all strings with filenames between the dates" do # fix?
        some_sample_links = [
          "/2014/ipg140107.zip", 
          "/2014/ipa140113.zip", 
          "/2014/ipg140114.zip", 
          "/2014/ipg140121.zip"]
        context "file prefix supplied" do
          it "only includes files with prefix" do
            selected_grants = rs.select_between(startdate: 140110, enddate: 140115, links: some_sample_links, prefix: "ipg")
            expect(selected_grants).to eq(["/2014/ipg140114.zip"])
          end
        end

        context "file prefix not supplied" do
          it "disregards prefix" do
            selected_grants = rs.select_between(startdate: 140110, enddate: 140115, links: some_sample_links, prefix: nil)
            expect(selected_grants).to eq(["/2014/ipa140113.zip", "/2014/ipg140114.zip"])
          end
        end
      end
    end
  end
end
