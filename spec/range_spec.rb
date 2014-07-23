require_relative 'spec_helper'

describe RangeHelper do
  def _get_local_grants_page # for convenience
    local_grants_path = $BASE_FILE_PATH + '/test_files/range_helper/uspto-patents-grants-text.html'
    local_grants_page = File.read local_grants_path
  end
  
  describe "#expand_range" do
    context "takes url, startdate, enddate, and prefix arguments" do
      it "returns all filenames between start and end dates" do
        VCR.use_cassette('grants_page') do
          filenames = RangeHelper.expand_range url: "http://www.google.com/googlebooks/uspto-patents-grants-text.html", startdate: "01-01-14", enddate: "01-15-14", prefix: "ipg"
          expect(filenames).to eq(["ipg140107", "ipg140114"])
        end
      end
    end
  end
end
