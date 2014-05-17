require 'rack'

module Salen
  class App
    HTTP_VERBS = %i(get post)

    def call env
      request = Rack::Request.new env
      handler = self.class.routes.fetch(request.request_method.downcase.to_sym).fetch(request.path)
      response = Rack::Response.new handler.call
      response["Content-Type"] = "text/html"
      response.finish
    end

    class << self
      def routes
        @routes ||= Hash.new {|h,k| h[k] = Hash.new(&h.default_proc) }
      end

      HTTP_VERBS.each do |method|
        define_method method do |path, &block|
          routes[method][path] = Proc.new &block
        end
      end

      def run!
        Rack::Builder.new.use Rack::CommonLogger
        Rack::Handler::WEBrick.run new
      end
    end
  end
end
