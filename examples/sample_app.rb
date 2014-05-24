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
end

SampleApp.run!
