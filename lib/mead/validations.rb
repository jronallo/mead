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

    def validate_format
      errors.clear
      self.class.format_validations.each do |validation|
        validation.call(self)
      end
    end

    def valid?
      validate_format
      validate
      errors.nil? or errors.empty?
    end

    def valid_format?
      validate_format
      errors.nil? or errors.empty?
    end

    def errors
      @errors ||= {}
    end

    module ClassMethods
      def validations
        @validations ||= []
      end

      def format_validations
        @format_validations ||= []
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
        validates_format do |instance|
          add_error(instance, :mead, "Can't be blank.") if instance.mead.nil? or instance.mead.empty?
          # check the format of the whole thing
          # ua023_031-001-cb0003-005-001
          unless instance.mead.to_s =~ format_regexp
            add_error(instance, :mead, 'Does not match regular expression.')
          end
        end
      end

      def validates_presence_of_mead
        validates do |instance|
          begin
            if instance.metadata
              result = instance.metadata
            else
              result = Mead::Extractor.new(instance).extract
            end
            if result.nil? or result.empty?
              add_error(instance, :mead, 'No matching container.')
            # even if the instance.series is 1 there may not be any series in the EAD XML yet
            elsif result.last[:series_sequence] and instance.series != result.last[:series_sequence].to_s
              add_error(instance, :mead, 'Bad series.')
            end
          rescue => e
            add_error(instance, :mead, e)
          end
        end
      end

      def validates_numericality_of_mead(*attributes)
        validates_attributes(*attributes) do |instance, attribute, value, options|
          if value
            unless value.to_s =~ /\A[+-]?\d+\Z/
              add_error(instance, attribute, "Not a number.")
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

      def validates_format(&proc)
        format_validations << Proc.new{|instance|
          proc.call(instance)
        }
      end


    end

  end
end

