require_relative 'spec_helper'

describe RunTemplate do

  let(:rt) { RunTemplate.new }
  grant_script_hash = {patent_prefix: "ipg", page_url: "http://www.google.com/googlebooks/uspto-patents-grants-text.html"}

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

