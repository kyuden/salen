require 'salen'

class SampleApp < Salen::App
  get '/' do
    'Hello world'
  end

  post '/kyuden' do
    'kyuden world'
  end
end

SampleApp.run!
