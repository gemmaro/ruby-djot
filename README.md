# Djot

[Djot](https://djot.net/) parser for Ruby, using original JavaScript ([jdm/djot.js](https://github.com/jgm/djot.js)) and Lua ([djot.lua](https://github.com/jgm/djot.lua)) implementations.

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell-session
bundle add djot
```

If bundler is not being used to manage dependencies, install the gem by executing:

```shell-session
gem install djot
```

## Usage

```ruby
require 'djot'
Djot.render_html('This is *djot*')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake test-unit` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine,
run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`,
which will create a git tag for the version,
push git commits and the created tag,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

### TODO

* Use [Attach global Ruby functions to your JavaScript context](https://github.com/rubyjs/mini_racer#attach-global-ruby-functions-to-your-javascript-context) for the functions' options which accepts lambda expressions.
* Create document class (and more) for idiomatic control in Ruby.
* Write parser in pure Ruby.
* Make JavaScript version as default. Currently the default is Lua version.
* Update Lua implementation from djot to djot.lua.

## Contributing

Bug reports and pull requests are welcome on [GitLab](https://gitlab.com/gemmaro/ruby-djot).
This project is intended to be a safe,
welcoming space for collaboration,
and contributors are expected to adhere
to the [code of conduct](CODE_OF_CONDUCT.md).

## Acknowledgement

As mentioned earlier, this library only calls the original JavaScript and Lua implementations; the important work is done in those libraries.
The Lua implementation was sufficient to render in HTML, but thanks to the more Ruby-friendly JavaScript implementation, even more flexible operations can now be performed in Ruby.
This gem also uses [rails/execjs](https://github.com/rails/execjs) and [ruby-lua](https://github.com/glejeune/ruby-lua) to call JavaScript and Lua source codes respectibly.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Djot project's codebases,
issue trackers, chat rooms and mailing lists is expected
to follow the [code of conduct](CODE_OF_CONDUCT.md).
