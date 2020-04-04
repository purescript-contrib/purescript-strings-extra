{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "purescript-strings-extra"
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
, devDependencies = [ "numbers" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
