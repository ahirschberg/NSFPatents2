describe FilenameExtractor do
  describe "#extract_from_string" do
    it "extracts a filename from a string" do
      link  = "/2014/ipg140107.zip"
      expect(FilenameExtractor.extract_from_string link).to eq("ipg140107")
    end
  end
end

