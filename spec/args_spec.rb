require_relative 'spec_helper'

describe ArgsParser do
  context "when no command line args are passed" do
    it "prints help" do
      expect{ArgsParser.new [], "ipg"}.to output(/USAGE/i).to_stdout 
    end
  end

  context "when command line arguments are passed" do
    it "categorizes arguments" do
      ap = ArgsParser.new %w[garbage_command ipg123456 ipg123457 download], "ipg"
      expect(ap.args_hash).to include(filenames: ["ipg123456", "ipg123457"], download: true, garbage_commands: ["garbage_command"])
    end
    
    context "when no action args are passed" do
      it "assumes all actions"  do
        ap = ArgsParser.new ["no_action_args"], "ipg"
        expect(ap.args_hash).to include(download: true, unzip: true, parse: true, report: true)
      end
    end

    it "only accepts filenames of given prefix" do
      ap = ArgsParser.new %w[ipa123123 ipg234234], "ipg"
      expect(ap.args_hash).to include(filenames: ["ipg234234"], garbage_commands: ["ipa123123"])
    end

    it "takes ranges with [startdate to enddate]" do
      ap = ArgsParser.new %w[111222 to 222333 06/10/97 to not_a_date], "ipg"
      expect(ap.args_hash).to include(ranges: [["111222", "222333"], ["06/10/97", "not_a_date"]])
    end

    context "when commas used to separate arguments" do
      it "strips them from filenames and range ends" do
        ap = ArgsParser.new %w[ipg123456, 111222 to 222333, 06/10/97 to not_a_date], "ipg"
        expect(ap.args_hash).to include(
          filenames: ["ipg123456"],
          ranges: [["111222", "222333"], ["06/10/97", "not_a_date"]]
        )
      end

      it "only strips properly placed commas" do
        ap = ArgsParser.new %w[ipg123456, 140101, to 141231], "ipg"
        expect(ap.args_hash).to include(
          filenames: ["ipg123456"],
          ranges:    [["140101,", "141231"]]
        )
        ap = ArgsParser.new %w[140101, to, 141231], "ipg"
        expect(ap.args_hash).to include(ranges: [])
      end
    end

    context "when given incorrect commands" do
      it "records them to an array in the hash" do
        ap = ArgsParser.new %w[not_a_command], "ipg"
        expect(ap.args_hash).to include(garbage_commands: ["not_a_command"])
      end

      context "when given a block as an argument" do
        it "executes the block" do
          reciever = double()
          expect(reciever).to receive(:foo).with(["not_a_command"])
          ap = ArgsParser.new(%w[not_a_command], "ipg") {|garbage_commands| reciever.foo garbage_commands} 
        end
      end
    end

    context "when given correct commands" do
      it "records an empty array in the hash " do
        ap = ArgsParser.new %w[ipg123456 14101 to 141231], "ipg"
        expect(ap.args_hash).to include(garbage_commands: [])
      end
    end
  end
end
