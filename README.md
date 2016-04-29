# Surveymonkey [![Build Status](https://travis-ci.org/hakamadare/rubygem-surveymonkey.svg?branch=master)](https://travis-ci.org/hakamadare/rubygem-surveymonkey) [![Gem Version](https://badge.fury.io/rb/surveymonkey.svg)](http://badge.fury.io/rb/surveymonkey)

This is a client for the SurveyMonkey [RESTful API](http://developer.surveymonkey.com).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'surveymonkey'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install surveymonkey

## Usage

### Authentication

The SurveyMonkey API is built on [Mashery](http://www.mashery.com/) and works like other Mashery APIs.  To access it, you'll need an API key and an access token; you'll be prompted to create these when you create a SurveyMonkey developer account.

Your API key is bound to a particular "application"; once you're logged into the SurveyMonkey developer site, you can create applications.

Access tokens are created via OAuth; you can either create one-off access tokens via the SurveyMonkey API console, or you can implement an OAuth flow of your own; there's more documentation [here](https://developer.surveymonkey.com/mashery/guide_oauth).

This gem requires that you specify both the API key and the access token at runtime.  The access token can be changed between each API call; the API key is set once and then cannot be changed.  Both of these can be read from environment variables, _e.g._
```console
$ export SURVEYMONKEY_APIKEY=XXXXXXXXXXX
$ export SURVEYMONKEY_ACCESSTOKEN=YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
```

### API Methods

The SurveyMonkey API methods are documented [here](https://developer.surveymonkey.com/), under "API Methods".  They are implemented as class methods, which you call like so:
```ruby
[1] pry(main)> Surveymonkey.get_user_details
=> {"status"=>0,
 "data"=>
  {"user_details"=>
    {"username"=>"XXXXXX", "is_paid_account"=>true, "is_enterprise_user"=>false}}}
```

To pass parameters to an API method, pass a hash like so:
```ruby
[2] pry(main)> Surveymonkey.get_survey_list("page_size" => 5, "order_asc" => true)
=> {"status"=>0,
 "data"=>
  {"surveys"=>
    [{"survey_id"=>"XXXXXXXX"},
     {"survey_id"=>"XXXXXXXX"},
     {"survey_id"=>"XXXXXXXX"},
     {"survey_id"=>"XXXXXXXX"},
     {"survey_id"=>"XXXXXXXX"}],
   "page"=>1,
   "page_size"=>5}}
```

API method responses are parsed into Ruby data structures; do with them as you think best.

SurveyMonkey API responses include a `status` attribute.  The possible values of this attribute are documented upstream; `Surveymonkey::Client` inspects each API response and raises a `Surveymonkey::Error` if the status code is other than 0.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## To Do

* implement support for API v3
* validate API method parameters client-side rather than server-side
* more unit tests
* better exception handling

## Contributing

1. Fork it ( https://github.com/hakamadare/surveymonkey/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Esteemed Contributors

* @KazuyaMuroi
* @cescue
