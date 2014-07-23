#!usr/bin/env ruby

class ArgsParser

  POSSIBLE_ACTIONS = %w[download unzip parse report].freeze
  
  def initialize(args, file_prefix, &garbage_block)

    # Print help text and exit if no arguments are supplied
    if args.length == 0
      puts HELP_TEXT
      #exit 0
    end

    @args_hash = {}

    action_args, remaining_args = extract_actions(args)
    POSSIBLE_ACTIONS.each do |possible_action|
      @args_hash[possible_action.to_sym] = action_args.include?(possible_action) || action_args.empty?
    end

    @args_hash[:filenames], remaining_args = extract_filenames(remaining_args, build_filename_regex(file_prefix))
    @args_hash[:ranges], remaining_args    = extract_ranges(remaining_args)
    @args_hash[:garbage_commands]          = remaining_args

    if garbage_block and @args_hash[:garbage_commands].any? 
      garbage_block.call @args_hash[:garbage_commands]
    end
  end

  attr_accessor :args_hash

  private
  def build_filename_regex(patent_prefix)
    filename_regex_prefix = '^'
    filename_regex_suffix = '\d{6}(?:\.\w*)?,?$' # takes into account the optional comma
    Regexp.new(filename_regex_prefix + patent_prefix + filename_regex_suffix)
  end
  def extract_actions(args)
    action_args = args.select {|arg| POSSIBLE_ACTIONS.include? arg}
    return action_args, args - action_args
  end
    
  def extract_filenames(args, file_regex)
    filenames = args.select {|arg| arg =~ file_regex}
    return filenames.map {|f| remove_tailing_comma_from_arg f}, args - filenames
  end

  # TODO refactor when it becomes clear what range formats we will use
  def extract_ranges(args)
    ranges = []
    args.each_with_index do |arg, index|
      if arg.downcase == "to"
        startdate, enddate = args[index-1], args[index+1]
        enddate = remove_tailing_comma_from_arg enddate
        ranges.push [startdate, enddate]

        # remove startdate, enddate, and "to" from args so that they don't show up in garbage
        # probably a better way to do this
        (-1..1).each {|offset| args[index + offset] = ""}
      end
    end
    return ranges, args.reject {|arg| arg == ""} 
  end

  def remove_tailing_comma_from_arg(arg)
    arg[-1] == ',' ? arg[0...-1] : arg
  end

HELP_TEXT = %Q{\033[33m===============================================
USAGE: ruby run.rb [OPTIONS]

Where OPTIONS is any combination of:
ACTIONS: 
  download - downloads  files specified by filenames
  unzip    - unzips     files specified by filenames
  parse    - parses     files specified by filenames
  report   - reports on files specified by filenames
  NOTE:
    Ommitting all actions will carry out all of them. (badly worded)
FILENAMES:
  Strings in format ip(a|g)xxxxxx[.xxx]
===============================================\033[0m}.freeze

end
