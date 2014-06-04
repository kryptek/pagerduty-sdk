pagerduty-sdk
=============

pagerduty-sdk is a Ruby Gem for communicating with the entire
[Pagerduty](http://www.pagerduty.com) API. It was designed to be as
fully object-oriented as possible. Although it is still under some
construction, it is functional and ready for use. 

I plan to do much more work on this gem, and your feedback is greatly
appreciated!

## Requirements
* Ruby 1.9.3+
* A Pagerduty account token

## Installation
```
gem install pagerduty-sdk
```

### Building/Installing a local gem

Rake tasks to build and install the gem:

```
rake buildgem
rake installgem
```

Or in one fell swoop

```
rake gem
```

## Usage
```ruby
require 'pagerduty'

pagerduty = Pagerduty.new(token: "#{token}", subdomain: "#{subdomain}")
#<Pagerduty:0x007f9a340fc410>
```

See [YARD documentation](http://rubydoc.info/github/kryptek/pagerduty-sdk/master/frames) for specific function usage.
