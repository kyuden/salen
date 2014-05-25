require 'rack'
require 'tilt'

module Salen
  class App
    HTTP_VERBS = %i(get post)

    def call env
      request = Request.new env
      response = Response.new request.body(self.class), request.status, request.headers
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
        app = new
        builder =
          Rack::Builder.new do
            run app
            use Rack::ShowExceptions
            use Rack::CommonLogger
            use Rack::Lint
          end

        Rack::Handler::WEBrick.run builder
      end
    end
  end

  class Request < Rack::Request
    attr_accessor :headers, :status, :params, :route_body

    def initialize env
      @headers = {'Content-Type' => 'text/html'}
      @status  = 200
      super env
    end

    def redirect_to uri
      @headers = { "Location" => uri }
      @status  = 301
    end

    def haml template
      render :haml, template_path(template, '.html.haml')
    end

    def template_path template, extention
      File.join('views', template + extention)
    end

    def render engin, template
      Tilt.new(template).render
    end

    def body app_class
      dispatch_route(app_class.routes.fetch(request_method.downcase.to_sym), path)
      [instance_eval(&route_body.last).to_s]
    end

    private

      def dispatch_route routes, path
         @params = Hash[params_values(routes).zip(params_keys)].invert
      end

      def params_keys
        keys = []
        route_body.first.gsub %r<:([^/])+> do |k,v|
          keys.push k.delete!(':').to_sym
        end
        keys
      end

      def params_values routes
        vals = []
        @route_body =
        routes.detect do |k,v|
          path.match Regexp.new("^"+k.gsub(%r<:([^/])+>, "([^/])+")+"$") do |md|
            vals = md[1..-1]
          end
        end
        vals
      end
  end

  class Response < Rack::Response
  end
end
