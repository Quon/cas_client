module CasClient
  
  module Response
    
    class Base
      
      class << self
        
        include CasClient::Logger
        
        def parse(response_body)
          logger.debug("[CAS] Received from server: #{response_body.inspect}")
          document = Nokogiri::XML(response_body)
          if !document.xpath("//*[name() = 'cas:authenticationSuccess']").empty?
            CasClient::Response::Success.new(document)
          elsif !document.xpath("//*[name() = 'cas:authenticationFailure']").empty?
            CasClient::Response::Failure.new(document)
          else
            raise "Can't parse response body"
          end
        rescue => e
          raise CasClient::Error.new(e)
        end
        
      end
      
      attr_reader :document
      
      def initialize(document)
        @document = document
      end
      
    end
    
  end
  
end