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
        Rack::Builder.new.use Rack::CommonLogger
        Rack::Handler::WEBrick.run new
      end
    end
  end

  class Request < Rack::Request
    attr_accessor :headers, :status

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
       body_proc = app_class.routes.fetch(request_method.downcase.to_sym).fetch(path)
       [instance_eval(&body_proc).to_s]
    end
  end

  class Response < Rack::Response
  end
end
