module Mead
  class Container
    attr_accessor :identifier, :localtype, :label, :text

    def initialize(options={})
      @localtype = options[:localtype]
      @label = options[:label]
      @identifier = options[:identifier]
      @text = options[:text]
    end

    def ==(another_container)
      self.identifier == another_container.identifier and
      self.localtype == another_container.localtype and
      self.label == another_container.label and
      self.text == another_container.text
    end

    def to_json(*a)
     h = {
       'json_class'   => self.class.name
     }
     self.instance_variables.each do |var|
       h[var.sub('@','').to_sym] = self.send(var.sub('@','').to_sym)
     end
     h.to_json(*a)
   end

  end
end
