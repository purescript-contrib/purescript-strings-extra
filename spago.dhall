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
  , "strings"
  , "unicode"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
