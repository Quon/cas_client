module CasClient
  
  module Response
    
    class Profile
      
      def initialize(values)
        @values = values.inject({}) do |options, (key, value)|
          options[key.to_s] = value
          options
        end
      end
      
      def [](key)
        @values[key.to_s]
      end
      
    end
    
  end
  
end