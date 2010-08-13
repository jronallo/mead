module Mead
  class Ead
    # factor out :baseurl, :file and :url into an options object?
    attr_accessor :containers, :ead, :baseurl, :file, :url, :doc, :eadid

    # options include :file and :base_url
    def initialize(opts={})
      @eadid = opts[:eadid] || nil
      @file    = opts[:file] || nil
      @baseurl = opts[:baseurl] || nil
      @url     = opts[:url] || nil
      @containers = []
      
      get_ead
      find_eadid unless @eadid
      crawl_for_containers     
    end

    def get_ead
      if @eadid.nil? and @url.nil? and @file.nil? and @baseurl
        raise 'Cannot get EAD based on params.'
      end
      if @file and @file.is_a? File
        @file.rewind if @file.eof?
        @ead = @file.read
      elsif @url
        @ead = open(@url).read
      elsif @baseurl
        @ead = open(File.join(@baseurl, @eadid + '.xml')).read
      end
      @doc = Nokogiri::XML(@ead)  
    end

    def find_eadid
      begin
        @eadid = @doc.xpath('//xmlns:eadid').first.text
      rescue => e
        raise 'Need an eadid and none has been given and it cannot be found in the EAD XML.'
      end
    end

    def crawl_for_containers      
      c01s = @doc.xpath('//xmlns:dsc/xmlns:c01')
      c01s.each_with_index do |c, i|
        dids = c.xpath('.//xmlns:container').map{|c| c.parent}.uniq
        #c.xpath('xmlns:c02/xmlns:did').map do |did|
        dids.map do |did|
          info = {}
          info[:series] = i + 1
          info[:mead] = create_mead(did, i)
          info[:title] = concat_title(did)
          @containers << info
        end
      end
    end

    def create_mead(did, i)
      mead = [@eadid.dup]
      mead << "%03d" % (i + 1) #series
#      mead << 'c1'  #container 1
#      mead <<  'c2' #container 2
      mead << specific_containers(did)
      mead << '001' # stub for first record
      @mead = mead.flatten.join('-')
    end

    def concat_title(did)
      title = ''
      title << did.xpath('xmlns:unittitle').text if did.xpath('xmlns:unittitle')
      if did.xpath('xmlns:unittitle') and did.xpath('xmlns:unitdate') and !did.xpath('xmlns:unitdate').text.empty?
        title << ', ' << did.xpath('xmlns:unitdate').text
      end
      if did.xpath('xmlns:unitid') and !did.xpath('xmlns:unitid').text.empty?
        title << ' (' + did.xpath('xmlns:unitid').text + ')'
      end
      title
    end

    def specific_containers(did)
      containers = did.xpath('xmlns:container')
      container_values = []
      if containers.length == 1
        container_values << make_box(did.xpath('xmlns:container')[0])
        container_values << '000'
      elsif containers.length == 2
        container_values << make_box(did.xpath('xmlns:container')[0])
        container_values << make_box(did.xpath('xmlns:container')[1],3)
      elsif containers.length > 2
        raise "I don't know what to do with more than 2 containers in a did!"
      else
        raise "Do we really have zero containers?!"
      end
      return container_values
    end

    def make_box(container, padding=4)
      padder = "%0" + padding.to_s + 's'
      text = (padder % container.text).gsub(' ','0').gsub('.','_').gsub('-', ',')
      container_type(container) + text
    end

    def container_type(container)
      match =''
      CONTAINER_MAPPING.each do |k,v|
        if container.attribute('type').text == v or
            container.attribute('type').text.downcase == v
          match = k
        end
      end
      match
    end

    def to_csv
      Mead::Ead.to_csv(self.containers)
    end
    
    def self.to_csv(container_list)
      if CSV.const_defined? :Reader
        csv_class = FasterCSV # old CSV was loaded
      else
        csv_class = CSV # use CSV from 1.9
      end
      csv_string = csv_class.generate do |csv|
        csv << ['mead','title','series']
        container_list.each do |container|
          csv << [container[:mead], container[:title], container[:series]]
        end
      end
    end
    
    def valid?
      meads = @containers.collect{|container| container[:mead]}.uniq
      if meads.length == @containers.length
        true
      else
        false
      end        
    end
    
    def invalid
      duplicates = dups
      @containers.select{|container| duplicates.include?(container[:mead])}
    end
    
    def dups
      meads.inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys.sort
    end
    
    def meads
      @containers.collect{|container| container[:mead]}
    end

  end
end
