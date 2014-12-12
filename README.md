# HackCentral

The best way to organize and run a hackathon.

If you're looking for the server setup HackCentral repo, check it out [here](https://github.com/hackcentral/server-stuff).

## API

(documentation coming soon)

We have an official OmniAuth strategy available as a gem:

Add to Gemfile:

```ruby
gem 'omniauth-hackcentral'
```

Now are you are ready to use!

```ruby
use OmniAuth::Builder do
  provider :hackcentral, ENV['HACKCENTRAL_APPLICATION_ID'], ENV['HACKCENTRAL_APP_SECRET']
end
```

Want to contribute? Check out the source code on [GitHub](https://github.com/hackcentral/omniauth-hackcentral).
