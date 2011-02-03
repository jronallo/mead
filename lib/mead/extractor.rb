module Mead
  class Extractor

    attr_accessor :mead, :dsc, :series, :doc, :ead_location, :stack, :node

    # a stack contains the data (unittitle, unitdate) from the identifier's
    # container all the way through to parent containers. The order is from
    # most specific to least specific
    def initialize(mead)
      @stack = []
      get_mead_obj(mead)
      self
    end

    def extract
      get_ead_location
      eadxml = get_eadxml
      @doc = Nokogiri::XML(eadxml)
      do_extraction
      @mead.metadata = @stack # make sure the metadata always gets cached to the identifier
      return @stack
    end

    private

    def get_mead_obj(mead)
      if mead.is_a? Mead::Identifier
        @mead = mead
      else
        raise "is not a Mead::Identifier"
      end
    end

    def get_ead_location
      if mead.ead_location
        @ead_location = mead.ead_location
      else
        raise 'Cannot extract because no Ead location defined in Mead::Identifier.'
      end
    end

    def do_extraction
      get_dsc
      get_series
      find_node
      push_to_stack(@node)
    end

    def push_to_stack(node)
      return nil if node.nil?
      additional_did = {:unittitle => container_field('unittitle', node),
        :unitdate => container_field('unitdate', node),
        :level => container_level(node),
        :unitid => container_field('unitid', node)
      }
      did_location_text = did_location(node)
      additional_did[:item_location] = did_location_text if did_location_text
      
      add_containers(additional_did, node)
      
      if additional_did[:level] == 'series'
        additional_did[:series_number] = series_number(node)
      end
      if @stack.last == additional_did
        return
      end
      @stack << additional_did
      if !node.parent.parent.xpath('xmlns:did').empty?
        push_to_stack(node.parent.parent.xpath('xmlns:did')[0])
      end
    end

    def add_containers(hash, node)
      if !node.xpath('./xmlns:container').empty?
        hash[:containers] = []
        node.xpath('./xmlns:container').each do |container|
          c = Mead::Container.new
          c.type = container.attribute('type').text if container.attribute('type')
          c.label = container.attribute('label').text if container.attribute('label')
          c.text = container.text if !container.text.empty?
          hash[:containers] << c
        end
      end
    end

    def did_location(did)
      location = []
      did.xpath('./xmlns:container').each do |container|
        location << container.attribute('type').text + ' ' + container.text
      end
      unless location.empty?
        location.join(', ')
      end
    end

    def get_series
      c01_series = @dsc.xpath(".//xmlns:c01[@level='series']")
      if c01_series and !c01_series.empty?
        c01_series.each_with_index do |c01, i|
          if mead.series.to_i == i + 1
            @series = c01
          end
        end
      else
        @series = @dsc
      end
    end
    
    def folder_types
      types = "@type='#{@mead.folder[:type]}' or @type='#{@mead.folder[:type].capitalize}'"
      if @mead.folder[:type] == 'folder'
        types << " or @type='envelope' or @type='Envelope'"
      end
      types
    end

    def find_node(folder=true)
      #dsc_dids = series.xpath('.//xmlns:did')
      if @mead.container[:type]    
        container_set_xpath = ".//xmlns:container[text()='#{@mead.container[:number]}' and (@type='#{@mead.container[:type]}' or @type='#{@mead.container[:type].capitalize}')]"
        if folder and @mead.folder
          container_set_xpath << "/../xmlns:container[text()='#{@mead.folder[:number]}' and (#{folder_types})]"
        end
        containers = series.xpath(container_set_xpath)
        #matching_dids
        if containers.length > 1
          raise "too many matching nodes!"
        elsif containers.length == 0
          # Second chance to handle legacy identifiers where a blank folder was given as 001
          if @mead.folder[:number] == '1'
            #@mead.folder = nil #TODO: check do 000 folders get automatically turned to nil when the mead is created?
            find_node(false)
          else
            raise "no matching dids!"
          end
        else
          @node = containers[0].parent
        end
      else
        return nil
      end
    end

    def container_field(field, node)
      xpath = 'xmlns:' + field
      if node.xpath(xpath)
        text = node.xpath(xpath).text
        if text.nil? or text.empty?
          return nil
        else
          return text
        end
      else
        nil
      end
    end

    def container_level(node)
      if node.parent['level']
        node.parent['level']
      else
        nil
      end
    end

    def series_number(node)
      parent_node = node.parent
      siblings = node.document.xpath('//xmlns:c01')
      length = siblings.length
      index = siblings.index(parent_node) + 1
      index
    end

    def get_dsc
      @dsc = @doc.xpath('//xmlns:dsc')
    end

    def get_eadxml
      tries = 5
      begin
        if @ead_location.respond_to? :read
          @ead_location.read
        else
          return open(@ead_location).read
        end
      rescue => e
        tries -= 1
        if tries > 0
          retry
        else
           raise "Could not get record by eadid! " + e.inspect
        end
      end
    end

  end
end

