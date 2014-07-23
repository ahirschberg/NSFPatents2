module RangeHelper
  class RangeSelector
    def self.select_between(args)
      args[:links].select do |filename|
        filename_matchdata = filename.match(/(?<prefix>ip[ag])(?<date>\d{6})/)
        filedate = filename_matchdata["date"]
        fileprefix = filename_matchdata["prefix"]

        filedate.to_i.between? args[:startdate].to_i, args[:enddate].to_i and
          desired_prefix? args[:prefix], fileprefix
      end
    end

    private 
    def self.desired_prefix?(user_inputted_prefix, parsed_prefix)
      if user_inputted_prefix.nil?
        return true
      else
        return user_inputted_prefix == parsed_prefix
      end
    end
  end
end
