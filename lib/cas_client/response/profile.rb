module CasClient
  
  module Response
    
    class Profile
      
      include CasClient::Logger
      include Enumerable
      
      def initialize(attributes)
        @attributes = attributes.with_indifferent_access
        if empty?
          logger.warn('[CAS] WARN: profile is empty')
        else
          logger.debug("[CAS] Profile is: #{self}")
        end
      end
      
      def attributes(*keys)
        returning({}.with_indifferent_access) do |attributes|
          keys.each do |key|
            value = @attributes[key]
            attributes[key] = value unless value.nil?
          end
        end
      end
      
      def each(&block)
        @attributes.each(&block)
      end
      
      def empty?
        @attributes.empty?
      end
      
      def value(key)
        @attributes[key.to_sym]
      end
      alias_method :[], :value
      
      def to_s
        @attributes.inspect
      end
      
    end
    
  end
  
end