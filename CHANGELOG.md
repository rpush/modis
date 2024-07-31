# Changelog

## [v4.1.0](https://github.com/rpush/modis/tree/v4.1.0) (2024-07-31)

[Full Changelog](https://github.com/rpush/modis/compare/v4.2.0...v4.1.0)

**Merged pull requests:**

- Add support for multiple redis connections [\#49](https://github.com/rpush/modis/pull/49) ([SxDx](https://github.com/SxDx))
- Fix deprecation warning [\#48](https://github.com/rpush/modis/pull/48) ([SxDx](https://github.com/SxDx))

## [v4.2.0](https://github.com/rpush/modis/tree/v4.2.0) (2023-08-01)

[Full Changelog](https://github.com/rpush/modis/compare/v4.1.0...v4.2.0)

**Merged pull requests:**

- Support redis gem v5.x [\#45](https://github.com/rpush/modis/pull/45) ([benlangfeld](https://github.com/benlangfeld))

## [v4.1.0](https://github.com/rpush/modis/tree/v4.1.0) (2023-02-01)

[Full Changelog](https://github.com/rpush/modis/compare/v4.0.1...v4.1.0)

**Closed issues:**

- Migrate CI to GitHub Actions, add testing for Rails 7.0 and Ruby 3.1 [\#33](https://github.com/rpush/modis/issues/33)

**Merged pull requests:**

- Prep v4.1.0 release [\#46](https://github.com/rpush/modis/pull/46) ([benlangfeld](https://github.com/benlangfeld))
- Upgrades to latest activesupport [\#44](https://github.com/rpush/modis/pull/44) ([benlangfeld](https://github.com/benlangfeld))
- Switch from Travis CI to GH actions [\#42](https://github.com/rpush/modis/pull/42) ([benlangfeld](https://github.com/benlangfeld))
- Flexible encoding [\#41](https://github.com/rpush/modis/pull/41) ([benlangfeld](https://github.com/benlangfeld))
- Compatibility with redis 4.8.x gem [\#40](https://github.com/rpush/modis/pull/40) ([benlangfeld](https://github.com/benlangfeld))
- Compatibility with redis 4.7.x gem [\#39](https://github.com/rpush/modis/pull/39) ([benlangfeld](https://github.com/benlangfeld))
- More modern ruby for local dev [\#37](https://github.com/rpush/modis/pull/37) ([benlangfeld](https://github.com/benlangfeld))
- Don't allow redis \> 4.6 yet [\#36](https://github.com/rpush/modis/pull/36) ([benlangfeld](https://github.com/benlangfeld))

## [v4.0.1](https://github.com/rpush/modis/tree/v4.0.1) (2022-03-02)

[Full Changelog](https://github.com/rpush/modis/compare/v4.0.0...v4.0.1)

**Merged pull requests:**

- Fix deprectated pipeline calls for Redis 4.6.0 [\#32](https://github.com/rpush/modis/pull/32) ([justinhoward](https://github.com/justinhoward))

## [v4.0.0](https://github.com/rpush/modis/tree/v4.0.0) (2021-04-28)

[Full Changelog](https://github.com/rpush/modis/compare/v3.3.0...v4.0.0)

**Closed issues:**

- remove hiredis dependency [\#15](https://github.com/rpush/modis/issues/15)

**Merged pull requests:**

- Makes hiredis a development dependency [\#31](https://github.com/rpush/modis/pull/31) ([fdocr](https://github.com/fdocr))

## [v3.3.0](https://github.com/rpush/modis/tree/v3.3.0) (2020-07-07)

[Full Changelog](https://github.com/rpush/modis/compare/v3.2.0...v3.3.0)

**Merged pull requests:**

- Fix deprecation warnings [\#30](https://github.com/rpush/modis/pull/30) ([rofreg](https://github.com/rofreg))
- Test with Ruby 2.7 [\#28](https://github.com/rpush/modis/pull/28) ([aried3r](https://github.com/aried3r))

## [v3.2.0](https://github.com/rpush/modis/tree/v3.2.0) (2019-12-12)

[Full Changelog](https://github.com/rpush/modis/compare/v3.1.0...v3.2.0)

**Merged pull requests:**

- Add missing `#update` and `#update!` persistance methods [\#27](https://github.com/rpush/modis/pull/27) ([dsantosmerino](https://github.com/dsantosmerino))

## [v3.1.0](https://github.com/rpush/modis/tree/v3.1.0) (2019-10-18)

[Full Changelog](https://github.com/rpush/modis/compare/3.0.0...v3.1.0)

**Closed issues:**

- Add testing for Rails 6 [\#24](https://github.com/rpush/modis/issues/24)
- Modis Memory Leak [\#14](https://github.com/rpush/modis/issues/14)
- Support of Rails 5.2 [\#13](https://github.com/rpush/modis/issues/13)

**Merged pull requests:**

- Remove i18n dependency [\#26](https://github.com/rpush/modis/pull/26) ([aried3r](https://github.com/aried3r))
- Test with Rails 6, Ubuntu 18.04, Ruby 2.6 [\#25](https://github.com/rpush/modis/pull/25) ([aried3r](https://github.com/aried3r))
- Fix build status badge [\#22](https://github.com/rpush/modis/pull/22) ([jas14](https://github.com/jas14))

## [3.0.0](https://github.com/rpush/modis/tree/3.0.0) (2018-12-20)

[Full Changelog](https://github.com/rpush/modis/compare/v2.1.0...3.0.0)

**Closed issues:**

- difficult to persist after making changes to part of a hash attribute [\#8](https://github.com/rpush/modis/issues/8)

**Merged pull requests:**

- Prep 3.0.0 release [\#21](https://github.com/rpush/modis/pull/21) ([garettarrowood](https://github.com/garettarrowood))
- Lock i18n version [\#20](https://github.com/rpush/modis/pull/20) ([garettarrowood](https://github.com/garettarrowood))
- Compatability with Rails 5.2's ActiveModel::Dirty [\#19](https://github.com/rpush/modis/pull/19) ([benlangfeld](https://github.com/benlangfeld))
- Resolve rubocop violations and lock version [\#17](https://github.com/rpush/modis/pull/17) ([garettarrowood](https://github.com/garettarrowood))
- Fix CI failures by resolving RuboCop offenses [\#12](https://github.com/rpush/modis/pull/12) ([garettarrowood](https://github.com/garettarrowood))
- get rid of old school rocket syntax [\#11](https://github.com/rpush/modis/pull/11) ([DmytroStepaniuk](https://github.com/DmytroStepaniuk))
- fix wrong readme example [\#10](https://github.com/rpush/modis/pull/10) ([DmytroStepaniuk](https://github.com/DmytroStepaniuk))

## [v2.1.0](https://github.com/rpush/modis/tree/v2.1.0) (2017-06-24)

[Full Changelog](https://github.com/rpush/modis/compare/v1.4.2...v2.1.0)

**Closed issues:**

- Reason of :all index [\#6](https://github.com/rpush/modis/issues/6)

**Merged pull requests:**

- New option for Modis::Model - :enable\_all\_index [\#7](https://github.com/rpush/modis/pull/7) ([nattfodd](https://github.com/nattfodd))

## [v1.4.2](https://github.com/rpush/modis/tree/v1.4.2) (2017-06-05)

[Full Changelog](https://github.com/rpush/modis/compare/v2.0.0...v1.4.2)

## [v2.0.0](https://github.com/rpush/modis/tree/v2.0.0) (2017-05-25)

[Full Changelog](https://github.com/rpush/modis/compare/v1.4.1...v2.0.0)

**Closed issues:**

- Drop support for Ruby \<= 2.1 [\#4](https://github.com/rpush/modis/issues/4)
- Spec errors in new optimizations [\#1](https://github.com/rpush/modis/issues/1)

**Merged pull requests:**

- Improvements [\#5](https://github.com/rpush/modis/pull/5) ([Tonkpils](https://github.com/Tonkpils))
- Support for Ruby 2.4.1 [\#3](https://github.com/rpush/modis/pull/3) ([Tonkpils](https://github.com/Tonkpils))

## [v1.4.1](https://github.com/rpush/modis/tree/v1.4.1) (2015-01-20)

[Full Changelog](https://github.com/rpush/modis/compare/v1.4.0...v1.4.1)

## [v1.4.0](https://github.com/rpush/modis/tree/v1.4.0) (2015-01-13)

[Full Changelog](https://github.com/rpush/modis/compare/v1.3.0...v1.4.0)

## [v1.3.0](https://github.com/rpush/modis/tree/v1.3.0) (2014-09-01)

[Full Changelog](https://github.com/rpush/modis/compare/v1.2.0...v1.3.0)

## [v1.2.0](https://github.com/rpush/modis/tree/v1.2.0) (2014-09-01)

[Full Changelog](https://github.com/rpush/modis/compare/v1.1.0...v1.2.0)

## [v1.1.0](https://github.com/rpush/modis/tree/v1.1.0) (2014-07-09)

[Full Changelog](https://github.com/rpush/modis/compare/v1.0.0...v1.1.0)

## [v1.0.0](https://github.com/rpush/modis/tree/v1.0.0) (2014-06-22)

[Full Changelog](https://github.com/rpush/modis/compare/v0.0.1...v1.0.0)

## [v0.0.1](https://github.com/rpush/modis/tree/v0.0.1) (2014-04-20)

[Full Changelog](https://github.com/rpush/modis/compare/a42bf2ff8e233a52ce1fb4fd3120f21cec8bee1c...v0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
