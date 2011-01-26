module Mead
  class Container
    attr_accessor :identifier, :type, :label, :text
    
    def initialize(options={})
      @type = options[:type]
      @label = options[:label]
      @identifier = options[:identifier]
      @text = options[:text]
    end
    
    def ==(another_container)
      self.identifier == another_container.identifier and
      self.type == another_container.type and
      self.label == another_container.label and
      self.text == another_container.text
    end
    
    
  end
end
