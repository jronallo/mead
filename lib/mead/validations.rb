module Mead
  module Validations
    def self.included(base)
      base.extend ClassMethods
    end

    def validate
      errors.clear
      self.class.validations.each do |validation|
        validation.call(self)
      end
    end

    def valid?
      validate
      errors.blank?
    end

    def valid_format?

    end

    def errors
      @errors ||= {}
    end

    module ClassMethods
      def validations
        @validations ||= []
      end

      def add_error(instance, attribute, message)
        if instance.errors[attribute]
          instance.errors[attribute] << message
        else
          instance.errors[attribute] = [message]
        end
      end
      
      # FIXME: This should be a more generic regular expression. Overriding this
      # method is the way to use a different regular expression during format
      # validation.
      def format_regexp
        container_codes = Mead::CONTAINER_MAPPING.keys.join('|') 
        #/^(ua\d{3}|mc\d{5})(_\d{3})?-\d{3}-(#{container_codes})\d{4}-\d{3}([A-Z])?-\d{3}(_\d{4})?$/ # NCSU specific
        # eadid        series box/container            folder       sequence   page
        /^([a-z0-9_]*)-\d{3}-(#{container_codes})\d{4}-\d{3}([A-Z])?-\d{3}(_\d{4})?$/
      end

      def validates_format_of_mead
        validates do |instance|        
          instance.errors[:mead] = "cant't be blank" if instance.mead.blank?
          # check the format of the whole thing
          # ua023_031-001-cb0003-005-001          
          unless instance.mead.to_s =~ format_regexp
            instance.errors[:mead] = 'Does not match regular expression.'
          end
        end
      end

      def validates_presence_of_mead
        validates do |instance|
          begin          
          extractor = Mead::Extractor.new(instance)
          result = extractor.extract
          if result.blank?
            instance.errors[:mead] = 'No matching container.'
          elsif instance.series != result.last[:series_number].to_s
            instance.errors[:mead] = 'Bad series.'
          end
          rescue => e
            instance.errors[:mead] = e
          end
        end
      end
      
      def validates_numericality_of_mead(*attributes)
        validates_attributes(*attributes) do |instance, attribute, value, options|
          if value
            unless value.to_s =~ /\A[+-]?\d+\Z/
              instance.errors[attribute] = "Not a number."
              next
            end
          end
        end
      end

      def validates_attributes(*attributes, &proc)
        validations << Proc.new { |instance|
          attributes.each {|attribute|
            proc.call(instance, attribute, instance.__send__(attribute))
          }
        }
      end
      
      def validates(&proc)
        validations << Proc.new{|instance|
          proc.call(instance)
        }
      end


    end

  end
end
