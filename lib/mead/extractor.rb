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
      c01s = @dsc.xpath('.//xmlns:c01')
      c01s.each_with_index do |c01, i|
        if mead.series.to_i == i + 1
          @series = c01
        end
      end
    end

    def find_node
      dsc_dids = series.xpath('.//xmlns:did')
      box_type = @mead.container[:type]
      if box_type
        box_xpath = %Q{xmlns:container[@type="#{box_type}"]}        
        folder_xpath = %Q{xmlns:container[@type='Folder' or @type='Envelope']}
        matching_dids = get_matching_dids(dsc_dids, box_xpath, folder_xpath)
        #matching_dids
        if matching_dids.length > 1
          raise "too many matching nodes!"
        elsif matching_dids.length == 0
          # Second chance to handle legacy identifiers where a blank folder was given 001
          if @mead.folder == '1'
            @mead.folder = nil
            find_node
          else
            raise "no matching dids!"
          end
        else
          @node = matching_dids[0]
        end
      else
        return nil
      end
    end
    
    def get_matching_dids(dsc_dids, box_xpath, folder_xpath)
      box_type = @mead.container[:type]
      box_xpath_capitalized = %Q{xmlns:container[@type="#{box_type.capitalize}"]}
      dsc_dids.map do |did|
        matches = []
        if @mead.folder.nil?
          matches << match_containers(did, box_xpath)
          matches << match_containers(did, box_xpath_capitalized)
        else
          matches << match_containers(did, box_xpath, folder_xpath)
          matches << match_containers(did, box_xpath_capitalized, folder_xpath)
        end
        matches
      end.flatten.uniq.compact
    end
    
    def folder_subs
      if Mead::CONTAINER_MAPPING.keys.include?(@mead.folder[0,2])
        folder_part = @mead.folder[2,10]
      else
        folder_part = @mead.folder
      end
      folder_part.gsub('_','.').gsub(',', '-').gsub(/^0*/,'')
    end

    def match_containers(did, box_xpath, folder_xpath=nil)
      if did.xpath(box_xpath)
        if !folder_xpath.nil?
          if !did.xpath(folder_xpath).empty?
            box_text = did.xpath(box_xpath).text
            folder_text = did.xpath(folder_xpath).text
            if box_text == @mead.container[:number] and folder_text == folder_subs
              return did
            end
          end
        else
          box_text = did.xpath(box_xpath).text
          return did if box_text == @mead.container[:number]
        end
      end
    end

    def container_field(field, node)
      xpath = 'xmlns:' + field
      if node.xpath(xpath)
        text = node.xpath(xpath).text
        if text.blank?
          return nil
        else
          return text
        end
      else
        nil
      end
    end

    #    def container_date(node)
    #      if node.xpath('xmlns:unitdate')
    #        node.xpath('xmlns:unitdate').text
    #      else
    #        nil
    #      end
    #    end
    #
    #    def container_id(node)
    #      if node.xpath('xmlns:unitid')
    #        node.xpath('xmlns:unitid').text
    #      else
    #        nil
    #      end
    #    end

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
