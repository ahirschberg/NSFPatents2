require_relative '../lib/run_template'

if __FILE__ == $0
  script_args = {
    page_url: "http://www.google.com/googlebooks/uspto-patents-applications-text.html",
    patent_prefix: "ipa"
  }
  rt = RunTemplate.new
  rt.run ARGV, script_args
end
