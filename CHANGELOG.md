# Changelog

## [Unreleased]

## [0.0.6] - 2023-01-31

Note again that the default parser might be changed from djot.lua to djot.js in future version.

### Added

* `Djot::Lua` module, which contains ex-`Djot.render_*` methods.
  Now `Djot.render_*` methods are pointers to `Djot::Lua.render_*` (default is not changed for this release).
* Option `warn` for `Djot::JavaScript.parse`.
* `Djot::JavaScript.parse_events` method.
* Option `warn` for `Djot::JavaScript.render_html`.
  (Option `overrides` are not yet supported.)
* Option `warn` and `smart_punctuation_map` for `Djot::JavaScript.to_pandoc`.
  (Please caution that `warn` options has not yet tested.)
* Option `warn` for `Djot::JavaScript.from_pandoc`.
  (Please caution that `warn` options has not yet tested.)

### Changed

* JavaScript runtime has changed from ExecJS to MiniRacer, for passing Ruby proc to JavaScript runtime.
  See also [rails/execjs#71 > Custom configuration of runtime](https://github.com/rails/execjs/issues/71).
* `Djot::JavaScript::VERSION` and `Djot::JavaScript::PATH` is deprecated.
  Use `Djot::JavaScript.version` and `Djot::JavaScript.path` instead.

## [0.0.5] - 2023-01-21

Note that the default parser might be changed from djot.lua to djot.js in future version.

### Added

* djot.js functionalities. Some options are not supported yet.
  * `Djot::JavaScript`
    * `parse`: `djot.parse`
    * `render_ast`: `djot.renderAST`
    * `render_html`: `djot.renderHTML`
    * `render_djot`: `djot.renderDjot`
    * `to_pandoc`: `djot.toPandoc`
    * `from_pandoc`: `djot.fromPandoc`
    * `version`: `djot.version`

## [0.0.4] - 2023-01-03

### Fixed

* Lua script loading

### Others

* Preparing for djot.js...

## [0.0.3] - 2022-09-25

### Added

* Tests from Djot test files

## [0.0.2] - 2022-09-03

### Fixed

* Repository URL

## [0.0.1] - 2022-09-03

Initial release.
