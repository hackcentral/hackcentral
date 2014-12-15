# HackCentral


[![Build Status](https://travis-ci.org/hackcentral/hackcentral.svg?branch=master)](https://travis-ci.org/hackcentral/hackcentral)
[![Coverage Status](https://coveralls.io/repos/hackcentral/hackcentral/badge.png)](https://coveralls.io/r/hackcentral/hackcentral)
[![Code Climate](https://codeclimate.com/github/hackcentral/hackcentral/badges/gpa.svg)](https://codeclimate.com/github/hackcentral/hackcentral)


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
