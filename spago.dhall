{ name = "strings-extra"
, dependencies =
  [ "arrays"
  , "assert"
  , "console"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "maybe"
  , "partial"
  , "prelude"
  , "psci-support"
  , "strings"
  , "unicode"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
