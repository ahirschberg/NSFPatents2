Gem::Specification.new do |s|
  s.name        = 'NSFPatents2'
  s.version     = '0.0.3'
  s.date        = '2014-07-22'
  s.summary     = 'Dowloads and parses patent files, searching for NSF data'
  s.description = 'Dowloads and parses patent files, searching for NSF data. If a patent or patent application is found to have a mention of NSF in the government interest field, the important fields are logged to a CSV.  It supports download of single files or ranges of files'

  s.authors     = ['Alex Hirschberg'] # (so far!)
  s.email       = 'TODO' # FIXME please
  s.homepage    = 'TODO' #FIXME
  s.files = [ 'bin/run_app.rb', #FIXME
              'bin/run_grant.rb',
              'lib/run_template.rb',
              'lib/args_helper.rb',
              'lib/range_helper.rb',
              'lib/util.rb', 
              'spec/spec_helper.rb',
              'spec/args_spec.rb', 
              'spec/range_spec.rb',
              'spec/util_spec.rb']

  s.license     = 'none' # FIXME
  #s.executables << nil
end
