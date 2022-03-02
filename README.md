# Strings Extra

[![CI](https://github.com/purescript-contrib/purescript-strings-extra/workflows/CI/badge.svg?branch=main)](https://github.com/purescript-contrib/purescript-strings-extra/actions?query=workflow%3ACI+branch%3Amain)
[![Release](http://img.shields.io/github/release/purescript-contrib/purescript-strings-extra.svg)](https://github.com/purescript-contrib/purescript-strings-extra/releases)
[![Pursuit](http://pursuit.purescript.org/packages/purescript-strings-extra/badge)](http://pursuit.purescript.org/packages/purescript-strings-extra)

Additional utilities for the PureScript Strings library.

## Installation

Install `strings-extra` with [Spago](https://github.com/purescript/spago):

```sh
spago install strings-extra
```

## Quick start

This library provides a simple grab bag of utilities that augment the core `strings` library for PureScript. Install the library and use the functions you need. If you come up with a new function you'd like to upstream to this library, please open a pull request!

```purs
module MyModule where

import Data.String.Extra (words, kebabCase)

kebabCaseAll :: String -> Array String
kebabCaseAll = kebabCase <<< words
```

## Documentation

`strings-extra` documentation is stored in a few places:

1. Module documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-strings-extra).
2. Written documentation is kept in [the docs directory](./docs).
3. Usage examples can be found in [the test suite](./test).

If you get stuck, there are several ways to get help:

- [Open an issue](https://github.com/purescript-contrib/purescript-strings-extra/issues) if you have encountered a bug or problem.
- Ask general questions on the [PureScript Discourse](https://discourse.purescript.org) forum or the [PureScript Discord](https://purescript.org/chat) chat.

## Contributing

You can contribute to `strings-extra` in several ways:

1. If you encounter a problem or have a question, please [open an issue](https://github.com/purescript-contrib/purescript-strings-extra/issues). We'll do our best to work with you to resolve or answer it.

2. If you would like to contribute code, tests, or documentation, please [read the contributor guide](./CONTRIBUTING.md). It's a short, helpful introduction to contributing to this library, including development instructions.

3. If you have written a library, tutorial, guide, or other resource based on this package, please share it on the [PureScript Discourse](https://discourse.purescript.org)! Writing libraries and learning resources are a great way to help this library succeed.
