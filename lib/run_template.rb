require_relative 'args_helper'
require_relative 'range_helper'
require_relative 'util'

class RunTemplate
  selected_filenames = nil

  def run(user_args, script_args)
    ap = ArgsParser.new(user_args, script_args[:patent_prefix]) {|garbage_commands| 
      warn("WARNING: the following arguments were not understood: #{garbage_commands}")
    }
    self.selected_filenames = handle_args ap.args_hash, script_args
  end

  def handle_args(user_args, script_args)

    filenames_to_use = user_args[:filenames]

    user_args[:ranges].each do |range_arr|
      filenames_in_range = RangeHelper.expand_range({
        startdate: range_arr[0],
        enddate:   range_arr[1], 
        url:       script_args[:page_url],
        prefix:    script_args[:patent_prefix] })
      filenames_to_use.push *filenames_in_range
    end

    filenames_to_use
  end

  attr_accessor :selected_filenames
end

if __FILE__ == $0
  rt = RunTemplate.new
  rt.run(%w[ipa123456, poop], {patent_prefix: "ipa", page_url: "google.com"})
end
