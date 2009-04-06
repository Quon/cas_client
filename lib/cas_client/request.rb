module CasClient
  
  class Request
    
    include CasClient::Logger
    
    class << self
      
      def validable?(params)
        params['ticket'].present?
      end
      
    end
    
    attr_reader :params
    attr_reader :provider
    attr_reader :service_url
    
    def initialize(service_url, params = {}, provider = ServiceProvider::Base.new)
      self.service_url = service_url
      @params = params.with_indifferent_access
      @provider = provider
    end
    
    def login_url(params = {})
      build_url(provider.login_url, params.reverse_merge(:service => service_url))
    end
    
    # Available options are: destination
    def logout_url(options = {})
      build_url(provider.logout_url, options.slice(:destination))
    end
    
    def signup_url(params = {})
      build_url(provider.signup_url, params.reverse_merge(:service => service_url))
    end
    
    def ticket
      params[:ticket]
    end
    
    # TODO SSL
    def validate(options = { :timeout => 5 })
      url = provider.validate_url
      logger.debug("[CAS] Posting request to: #{url}")
      logger.debug("[CAS] Service URL: #{service_url}")
      logger.debug("[CAS] Ticket: #{ticket}")
      # Building request
      request = Net::HTTP::Post.new(url.path)
      request.set_form_data(:service => service_url.to_s, :ticket => ticket)
      # Building connection
      cnx = Net::HTTP.new(url.host, url.port)
      cnx.open_timeout = options[:timeout]
      cnx.read_timeout = options[:timeout]
      # Starting connection
      cnx.start do |http|
        http.request(request) do |response|
          response.value # raise if not success
          return CasClient::Response::Base.parse(response.body)
        end
      end
    rescue Timeout::Error, StandardError => e
      raise CasClient::Error.new(e, url)
    end
    
    private
    
    def build_url(url, params)
      url = url.dup
      query = params.map do |name, value|
        next if value.nil?
        "#{name}=#{CGI.escape(value.to_s)}"
      end.join('&')
      url.query = query if query.present?
      url
    end
    
    def service_url=(url)
      @service_url = url.is_a?(URI) ? url : URI.parse(url)
      @service_url.fragment = nil
      params = (@service_url.query || '').split('&').inject({}) do |h, chunk| 
        key, value = chunk.split('=', 2)
        h[key] = value
        h
      end
      query = params.except('ticket').to_query
      query = nil if query.empty?
      @service_url.query = query
    rescue => e
      raise CasClient::Error.new(e)
    end
    
  end
  
end