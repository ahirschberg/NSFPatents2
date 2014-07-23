require_relative 'spec_helper'

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
end
