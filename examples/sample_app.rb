lib = File.expand_path('./lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pry"
require "pry-debugger"
require "pp"
require 'salen'

class SampleApp < Salen::App
  get '/' do
    'Hello world'
  end

  get '/kyuden' do
    redirect_to "/"
  end

  get '/recipe' do
    haml 'index'
  end

  get '/hello/:name' do
    params[:name]
  end
end

SampleApp.run!
