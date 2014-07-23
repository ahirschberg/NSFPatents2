require_relative '../lib/run_template'
require_relative '../lib/exceptions'
require_relative '../lib/args_helper'
require_relative '../lib/range_helper'
require_relative '../lib/util'
require_relative '../lib/file_getter'
require_relative '../lib/file_unzipper'

require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = $BASE_FILE_PATH + '/spec/cassettes'
  c.hook_into :webmock
end
