module Mead
  module TrollopOptions
    def check_options(opts)
      number_of_get_methods = [:baseurl, :url, :file].inject(0) do |memo, option| 
        temp_memo = memo
        temp_memo += 1 if opts[option]
        temp_memo
      end
      if number_of_get_methods > 1
        Trollop::die 'Must specify ONLY one way to get the Ead XML' 
      elsif number_of_get_methods == 0
        Trollop::die 'Must specify at least one way to get the Ead XML' 
      end
    end
    
    def get_location_options(opts)
      location_options = {}
      if opts[:baseurl]
        location_options[:baseurl] = opts[:baseurl]
      elsif opts[:url]
        location_options[:url] = opts[:url]
      elsif opts[:file]
        location_options[:file] = File.open(opts[:file])
      end
      location_options
    end
    
    def get_location(opts)
      if opts[:baseurl]
        opts[:baseurl]
      elsif opts[:url]
        opts[:url]
      elsif opts[:file]
        File.open(opts[:file])
      end
    end
  end
end
