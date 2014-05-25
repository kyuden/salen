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
