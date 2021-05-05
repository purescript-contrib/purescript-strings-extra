{ name = "strings-extra"
, dependencies =
  [ "arrays"
  , "assert"
  , "console"
  , "effect"
  , "foldable-traversable"
  , "integers"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "strings"
  , "unicode"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
