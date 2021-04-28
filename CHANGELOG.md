## Unreleased

## v4.0.0 - 2021-04-28

**Breaking:**

- Drop support for Rails 4.2, 5.0, 5.1.
- Removed `hiredis` as a dependency and made it a development dependency.
  For details, see [#31](https://github.com/rpush/modis/pull/31) by [@fdoxyz](https://github.com/fdoxyz).

## v3.3.0 - 2020-07-07

- Fix deprecation warnings when using Ruby >= 2.7, `activemodel` >= 6.0.3, or `redis` >= 4.2.0. [#30](https://github.com/rpush/modis/pull/30) by [@rofreg](https://github.com/rofreg).

## v3.2.0 - 2019-12-12

- Add missing `#update` and `#update!`. [#27](https://github.com/rpush/modis/pull/27) by [@dsantosmerino](https://github.com/dsantosmerino).

## v3.1.0 - 2019-10-18

- Test with Rails 6
- Drop i18n dependency (credit goes to [@jas14](https://github.com/jas14) in [#23](https://github.com/rpush/modis/pull/23))

## v3.0.0 - 2018-12-20

- Drop support for any Ruby < 2.3 and Rails < 4.2.
- Add support for Rails 5.2
- Resolve Rubocop lint violations
- Test combinations of Ruby and Rails versions in CI

## v2.1.0

- Add `enable_all_index` option to allow disabling the `all` keys. [#7](https://github.com/rpush/modis/pull/7)

## v2.0.0

- Support MRI 2.2.2+ and JRuby 9k+ [#5](https://github.com/rpush/modis/pull/5)
- Remove YAML (de)serialization support [#5](https://github.com/rpush/modis/pull/5)
