describe RangeHelper do
  describe RangeHelper::RangeFormatStandardizer do

    let(:rfs) {RangeHelper::RangeFormatStandardizer}

    describe "#standardize_range_formats" do
      context "when given start and end date" do 
        it "standardizes format" do
          expect(rfs.standardize_range_formats "01-01-14", "01-31-14").to eq(["140101", "140131"])
          expect(rfs.standardize_range_formats "01/01/14", "01/31/14").to eq(["140101", "140131"])
          expect(rfs.standardize_range_formats "140101", "140131").to eq(["140101", "140131"]) 
        end

        it "expands and standardizes shorthands" do
          expect(rfs.standardize_range_formats "14", "14").to eq(["140000", "149999"])
          expect(rfs.standardize_range_formats "2014", "2014").to eq(["140000", "149999"])
          expect(rfs.standardize_range_formats "14", "15").to eq(["140000", "159999"])
          expect(rfs.standardize_range_formats "2014", "2015").to eq(["140000", "159999"])
        end

        context "when date not understood raises exception" do
          it "only includes incorrect dates in message" do #split into two tests?
            expect{rfs.standardize_range_formats "not-a-range", "140101"}.to raise_error { |error|
              expect(error).to be_a(BetterNSFPatents::RangeFormatError)
              expect(error.message).to include("not-a-range")
              expect(error.message).not_to include("140101")
            }

            expect{rfs.standardize_range_formats "not-a-range", "also-incorrect"}.to raise_error { |error|
              expect(error).to be_a(BetterNSFPatents::RangeFormatError)
              expect(error.message).to include("not-a-range", "also-incorrect")
            }
          end
        end
      end
    end
  end
end
