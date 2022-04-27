# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Breaking changes:

New features:

Bugfixes:

Other improvements:

## [v4.0.0](https://github.com/purescript-contrib/purescript-strings-extra/releases/tag/v4.0.0) - 2022-04-27

Breaking changes:
- Update project and deps to PureScript v0.15.0 (#22 by @JordanMartinez)

New features:

Bugfixes:

Other improvements:
- Added `purs-tidy` formatter (#20 by @thomashoneyman)

## [v3.0.1](https://github.com/purescript-contrib/purescript-strings-extra/releases/tag/v3.0.1) - 2021-05-06

Other improvements:
- Fixed warnings revealed by v0.14.1 PS release (#18 by @JordanMartinez)
- Installed missing dependencies used in source code (#18 by @JordanMartinez)

## [v3.0.0](https://github.com/purescript-contrib/purescript-strings-extra/releases/tag/v3.0.0) - 2021-02-26

Breaking changes:
- Added support for PureScript 0.14 and dropped support for all previous versions (#14)

New features:

Bugfixes:

Other improvements:
- Updated `regexGlobal` to use `Data.String.Regex.Unsafe.unsafeRegex` (#13)
- Changed default branch to `main` from `master`

## [v2.2.1](https://github.com/purescript-contrib/purescript-strings-extra/releases/tag/v2.2.1) - 2020-10-02

- Updated casing functions internal implementation of splitting unicode words according to the lodash reference and move regexes up to the top level ([#11](https://github.com/purescript-contrib/purescript-strings-extra/pull/11))
- Updated to comply with Contributors library guidelines by adding new issue and pull request templates, updating documentation, and migrating to Spago for local development and CI (#9)

## [v2.2.0](https://github.com/purescript-contrib/purescript-strings-extra/releases/tag/v2.2.0) - 2020-09-13

- Exposed `upperCaseFirst` function

## [v2.1.0](https://github.com/purescript-contrib/purescript-strings-extra/releases/tag/v2.1.0) - 2020-04-08

- Added Levenshtein distance and Sorensen-Dice coefficient functions (@flip111)

## [v2.0.0](https://github.com/purescript-contrib/purescript-strings-extra/releases/tag/v2.0.0) - 2018-06-20

This release provides compatibility with PureScript 0.12 but does not change the public API.

- Update imports to 0.12 versions
- Replace `Data.String` imports with new `Data.String.CodeUnits` imports
- Remove effect rows from test suite

## [v1.0.0](https://github.com/purescript-contrib/purescript-strings-extra/releases/tag/v1.0.0) - 2017-10-02

- Initial release
