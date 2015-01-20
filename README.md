# HackCentral


[![Build Status](https://travis-ci.org/hackcentral/hackcentral.svg?branch=master)](https://travis-ci.org/hackcentral/hackcentral)
[ ![Codeship Status for hackcentral/hackcentral](https://codeship.com/projects/44c44710-7f36-0132-ec57-766d3855e68b/status?branch=master)](https://codeship.com/projects/57219)
[![Coverage Status](https://coveralls.io/repos/hackcentral/hackcentral/badge.png)](https://coveralls.io/r/hackcentral/hackcentral)
[![Dependency Status](https://gemnasium.com/hackcentral/hackcentral.svg)](https://gemnasium.com/hackcentral/hackcentral)
[![Code Climate](https://codeclimate.com/github/hackcentral/hackcentral/badges/gpa.svg)](https://codeclimate.com/github/hackcentral/hackcentral)


The best way to organize and run a hackathon.

If you're looking for the server setup HackCentral repo, check it out [here](https://github.com/hackcentral/server-stuff).

## Contributing

It's awesome you want to contribute! You're encouraged to submit pull requests, propose features and discuss issues.
Check out the [issue tracker](https://github.com/hackcentral/hackcentral/issues) for things that need to be worked on.

See [CONTRIBUTING](CONTRIBUTING.md) to get HackCentral setup on your local machine.

## License

MIT License. See LICENSE for details.

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
