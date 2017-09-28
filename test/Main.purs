module Test.Main where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.String.Extra as String
import Prelude (Unit, ($), (==), (*>), discard)
import Test.Assert (ASSERT, assert)

main :: forall eff. Eff (assert :: ASSERT, console :: CONSOLE | eff) Unit
main = do
  log "camelCase" *> do
    assert $ String.camelCase "" == ""
    assert $ String.camelCase " " == ""
    assert $ String.camelCase "\n" == ""
    assert $ String.camelCase "🙃" == "🙃"
    assert $ String.camelCase "Thor" == "thor"
    assert $ String.camelCase "Thor, Mímir, Ēostre, & Jörð" == "thorMímirĒostreJörð"
    assert $ String.camelCase "🙃, Mímir, ēostre, & Jörð" == "🙃MímirĒostreJörð"
    assert $ String.camelCase "thorMímir--Ēostre_Jörð" == "thorMímirĒostreJörð"

  log "kebabCase" *> do
    assert $ String.kebabCase "" == ""
    assert $ String.kebabCase " " == ""
    assert $ String.kebabCase "\n" == ""
    assert $ String.kebabCase "🙃" == "🙃"
    assert $ String.kebabCase "Thor" == "thor"
    assert $ String.kebabCase "Thor, Mímir, Ēostre, & Jörð" == "thor-mímir-ēostre-jörð"
    assert $ String.kebabCase "🙃, Mímir, ēostre, & Jörð" == "🙃-mímir-ēostre-jörð"
    assert $ String.kebabCase "thorMímir--Ēostre_Jörð" == "thor-mímir-ēostre-jörð"

  log "pascalCase" *> do
    assert $ String.pascalCase "" == ""
    assert $ String.pascalCase " " == ""
    assert $ String.pascalCase "\n" == ""
    assert $ String.pascalCase "🙃" == "🙃"
    assert $ String.pascalCase "Thor" == "Thor"
    assert $ String.pascalCase "Thor, Mímir, Ēostre, & Jörð" == "ThorMímirĒostreJörð"
    assert $ String.pascalCase "🙃, Mímir, ēostre, & Jörð" == "🙃MímirĒostreJörð"
    assert $ String.pascalCase "thorMímir--Ēostre_Jörð" == "ThorMímirĒostreJörð"

  log "snakeCase" *> do
    assert $ String.snakeCase "" == ""
    assert $ String.snakeCase " " == ""
    assert $ String.snakeCase "\n" == ""
    assert $ String.snakeCase "🙃" == "🙃"
    assert $ String.snakeCase "Thor" == "thor"
    assert $ String.snakeCase "Thor, Mímir, Ēostre, & Jörð" == "thor_mímir_ēostre_jörð"
    assert $ String.snakeCase "🙃, Mímir, ēostre, & Jörð" == "🙃_mímir_ēostre_jörð"
    assert $ String.snakeCase "thorMímir--Ēostre_Jörð" == "thor_mímir_ēostre_jörð"

  log "words" *> do
    assert $ String.words "" == []
    assert $ String.words " " == []
    assert $ String.words "\n" == []
    assert $ String.words "🙃" == [ "🙃" ]
    assert $ String.words "Thor" == [ "Thor" ]
    assert $ String.words "Thor, Mímir, Ēostre, & Jörð" == [ "Thor", "Mímir", "Ēostre", "Jörð" ]
    assert $ String.words "🙃, Mímir, Ēostre, & Jörð" == [ "🙃", "Mímir", "Ēostre", "Jörð" ]
    assert $ String.words "thorMímir--Ēostre_Jörð" == [ "thor", "Mímir", "Ēostre", "Jörð" ]
