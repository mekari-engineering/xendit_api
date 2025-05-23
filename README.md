# XenditApi

Ruby API wrapper for Xendit payment gateway

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xendit_api', git: 'git://github.com/mekari-engineering/xendit_api.git', branch: 'main'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install xendit_api

## Usage


### Create the client

There is multiple ways to create the client. 

```rb
client = XenditApi::Client.new('secret_key')

# when you need logs
XenditApi.configure do |config|
  config.logger = MyLogger.new
end
client = XenditApi::Client.new('secret_key')

# when you need to filter logs due to PII or security
client = XenditAPi::Client.new('secret_key', filtered_logs: [:card_cvv, :expected_amount], mask_params: [:email, :full_name])
```

When you need to filter logs, also make sure you already inject the logger object first, because we don't provide any default logger object. If you writing in Rails, you could use `Rails.logger`. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/xendit_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/xendit_api/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the XenditApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/xendit_api/blob/master/CODE_OF_CONDUCT.md).
