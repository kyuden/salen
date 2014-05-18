require 'salen'

class SampleApp < Salen::App
  get '/' do
    'Hello world'
  end

  get '/kyuden' do
    redirect_to "/"
  end
end

SampleApp.run!
