module VariableSwitcher
  
  def self.set_mode(mode)
    if mode == "app" or mode == "grant"
      $mode = mode
    else
      raise "Mode '#{mode}' must be app or grant"
    end
  end

  class ExampleCategory
    def self.links_page_url
      d = Decider.new "app_url", "grant_url"
      d.decision_block.call $mode
    end
  end

  private
  class Decider
    def initialize(app_value, grant_value)
      @decision_block = lambda do |mode|
        if mode == "app"
          app_value
        elsif mode == "grant"
          grant_value
        else
          raise "Mode '#{mode}' must be app or grant"
        end
      end
    end

    attr_accessor :decision_block
  end
end

if __FILE__ == $0
  VariableSwitcher.set_mode "app"

  VariableSwitcher::ExampleCategory.links_page_url
end
