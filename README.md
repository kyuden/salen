# Salen

Salen is a small and callow web application framework in Ruby.  

```ruby
require 'salen'

class SampleApp < Salen::App
  get '/' do
    'Hello Salen'
  end
end

SampleApp.run!
```

And run with:

```
ruby sample_app.rb
```

View at: http://localhost:8080

## Installation

Add this line to your application's Gemfile:

    gem 'salen'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install salen

## Routes

In Salen, a route is an HTTP method paired with a URL-matching pattern. Each route is associated with a block:

```ruby
get '/' do
  .. show something ..
end
```

Route patterns may include named parameters, accessible via the params hash:
```ruby
get '/hello/:name' do
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params[:name] is 'foo' or 'bar'
  "Hello #{params[:name]}!"
end
```
### Browser Redirect

You can trigger a browser redirect with the redirect helper method:

```ruby
get '/hello' do
  redirect_to "/"
end
```

## Views / Templates

Default template is haml 

```ruby
  get '/hello' do
    haml 'index'
  end
```

 


## Contributing

1. Fork it ( https://github.com/[my-github-username]/salen/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
