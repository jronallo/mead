module Mead
  class EAD
    attr_accessor :containers, :ead, :baseurl, :file_handle

    # options include :file_handle and :base_url
    def initialize(eadid, opts={})
      @eadid = eadid
      @file_handle = opts[:file_handle] || nil
      @baseurl = opts[:baseurl] || nil
      @containers = []
      get_ead
      crawl_for_containers     
    end

    def get_ead
      if @file_handle and @file_handle.is_a? File
        @ead = @file_handle.read
      elsif @baseurl
        @ead = open(File.join(@baseurl, @eadid + '.xml')).read
      end
    end

    def crawl_for_containers
      doc = Nokogiri::XML(@ead)      
      c01s = doc.xpath('//xmlns:dsc/xmlns:c01')
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
        container_values<< make_box(did.xpath('xmlns:container')[1],3)
      elsif containers.length > 2
        raise "I don't know what to do with more than 2 containers in a did!"
      else
        raise "Do we really have zero containers?!"
      end
      return container_values
    end

    def make_box(container, padding=4)
      padder = "%0" + padding.to_s + 's'
      text = (padder % container.text).gsub(' ','0').gsub('.','_')
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
      csv_string = FasterCSV.generate do |csv|
        csv << ['mead','title','series']
        @containers.each do |container|
          csv << [container[:mead], container[:title], container[:series]]
        end
      end
    end

  end
end
