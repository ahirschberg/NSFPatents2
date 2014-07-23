module RangeHelper
  class RangeFormatStandardizer
    def self.standardize_range_formats(startdate, enddate)
      possible_date_formats = [
      #mm-dd-yy, mm/dd/yy, mm-dd-yyyy, mm/dd/yyyy
        /^(?<month>\d{2})[-\/](?<day>\d{2})[-\/](?<year>\d{2}|\d{4})$/,
      #yymmdd
        /^(?<year>\d{2})(?<month>\d{2})(?<day>\d{2})$/,
      #yyyy, yy
        /^(?<year>\d{2}|\d{4})$/]

      matched_start, matched_end = nil
      possible_date_formats.each do |_format|
        matched_start = startdate.match _format unless matched_start #prevent overwrite
        matched_end   = enddate.match   _format unless matched_end
      end

      unless matched_start and matched_end
        err_message = generate_error_message FormatErrorBucket.new(startdate, matched_start), FormatErrorBucket.new(enddate,matched_end)
        raise BetterNSFPatents::RangeFormatError, err_message
      end
      
      formatted_startdate = format_startdate matched_start
      formatted_enddate   = format_enddate   matched_end

      return formatted_startdate, formatted_enddate
    end
    
    private
    FormatErrorBucket = Struct.new(:user_inputted_date, :matchdata)
    def self.generate_error_message(format_error_bucket1, format_error_bucket2=nil)
      format_error_buckets = [format_error_bucket1, format_error_bucket2].compact
      incorrect_dates = []
      format_error_buckets.each do |efb|
        unless efb.matchdata
          incorrect_dates.push efb.user_inputted_date
        end
      end

      error_plurality = nil
      error_ranges    = nil
      case incorrect_dates.size
      when 0
        return
      when 1
        error_ranges = incorrect_dates.first
      when 2
        error_plurality = "s"
        error_ranges    = "#{incorrect_dates.first} and #{incorrect_dates.last}"
      end

      "Range#{error_plurality} #{error_ranges} did not match any format. Please use yy[yy], mm/dd/yy[yy], or yymmdd formats"
    end
        
    def self.format_startdate(startdate)
      format_date startdate, "00"
    end
    
    def self.format_enddate(enddate) 
      format_date enddate, "99"
    end
    
    def self.format_date(matched, default_value)
      formatted_date = ""
      formatted_date << matched["year"][-2,2] #ensure only last two characters are taken from year

      if matched.names.include? "month" and matched.names.include? "day"
        formatted_date << matched["month"]
        formatted_date << matched["day"]
      else
        2.times {formatted_date << default_value} #adds month and day placeholder values
      end

      formatted_date
    end
  end
end
