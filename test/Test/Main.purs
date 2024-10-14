module Test.Main where

import Data.Int as Int
import Data.String.Extra as String
import Effect (Effect)
import Effect.Console (log)
import Prelude (Unit, ($), (==), (*>), discard, (*))
import Test.Assert (assert)

main :: Effect Unit
main = do
  log "camelCase" *> do
    assert $ String.camelCase "" == ""
    assert $ String.camelCase " " == ""
    assert $ String.camelCase "\n" == ""
    assert $ String.camelCase "ASCII" == "ascii"
    assert $ String.camelCase "🙃" == "🙃"
    assert $ String.camelCase "Thor" == "thor"
    assert $ String.camelCase "Thor, Mímir, Ēostre, & Jörð" == "thorMímirĒostreJörð"
    assert $ String.camelCase "🙃, Mímir, ēostre, & Jörð" == "🙃MímirĒostreJörð"
    assert $ String.camelCase "thorMímir--Ēostre_Jörð" == "thorMímirĒostreJörð"

  log "kebabCase" *> do
    assert $ String.kebabCase "" == ""
    assert $ String.kebabCase " " == ""
    assert $ String.kebabCase "\n" == ""
    assert $ String.kebabCase "ASCII" == "ascii"
    assert $ String.kebabCase "🙃" == "🙃"
    assert $ String.kebabCase "Thor" == "thor"
    assert $ String.kebabCase "Thor, Mímir, Ēostre, & Jörð" == "thor-mímir-ēostre-jörð"
    assert $ String.kebabCase "🙃, Mímir, ēostre, & Jörð" == "🙃-mímir-ēostre-jörð"
    assert $ String.kebabCase "thorMímir--Ēostre_Jörð" == "thor-mímir-ēostre-jörð"

  log "pascalCase" *> do
    assert $ String.pascalCase "" == ""
    assert $ String.pascalCase " " == ""
    assert $ String.pascalCase "\n" == ""
    assert $ String.pascalCase "ASCII" == "Ascii"
    assert $ String.pascalCase "🙃" == "🙃"
    assert $ String.pascalCase "Thor" == "Thor"
    assert $ String.pascalCase "Thor, Mímir, Ēostre, & Jörð" == "ThorMímirĒostreJörð"
    assert $ String.pascalCase "🙃, Mímir, ēostre, & Jörð" == "🙃MímirĒostreJörð"
    assert $ String.pascalCase "thorMímir--Ēostre_Jörð" == "ThorMímirĒostreJörð"

  log "snakeCase" *> do
    assert $ String.snakeCase "" == ""
    assert $ String.snakeCase " " == ""
    assert $ String.snakeCase "\n" == ""
    assert $ String.snakeCase "ASCII" == "ascii"
    assert $ String.snakeCase "🙃" == "🙃"
    assert $ String.snakeCase "Thor" == "thor"
    assert $ String.snakeCase "Thor, Mímir, Ēostre, & Jörð" == "thor_mímir_ēostre_jörð"
    assert $ String.snakeCase "🙃, Mímir, ēostre, & Jörð" == "🙃_mímir_ēostre_jörð"
    assert $ String.snakeCase "thorMímir--Ēostre_Jörð" == "thor_mímir_ēostre_jörð"

  log "upperCaseFirst" *> do
    assert $ String.upperCaseFirst "" == ""
    assert $ String.upperCaseFirst " " == " "
    assert $ String.upperCaseFirst "\n" == "\n"
    assert $ String.upperCaseFirst "ASCII" == "Ascii"
    assert $ String.upperCaseFirst "🙃" == "🙃"
    assert $ String.upperCaseFirst "Thor" == "Thor"
    assert $ String.upperCaseFirst "Thor, Mímir, Ēostre, & Jörð" == "Thor, mímir, ēostre, & jörð"
    assert $ String.upperCaseFirst "🙃, Mímir, ēostre, & Jörð" == "🙃, mímir, ēostre, & jörð"
    assert $ String.upperCaseFirst "thorMímir--Ēostre_Jörð" == "Thormímir--ēostre_jörð"

  log "words" *> do
    assert $ String.words "" == []
    assert $ String.words " " == []
    assert $ String.words "\n" == []
    assert $ String.words "ASCII" == [ "ASCII" ]
    assert $ String.words "🙃" == [ "🙃" ]
    assert $ String.words "Thor" == [ "Thor" ]
    assert $ String.words "Thor, Mímir, Ēostre, & Jörð" == [ "Thor", "Mímir", "Ēostre", "Jörð" ]
    assert $ String.words "🙃, Mímir, Ēostre, & Jörð" == [ "🙃", "Mímir", "Ēostre", "Jörð" ]
    assert $ String.words "thorMímir--Ēostre_Jörð" == [ "thor", "Mímir", "Ēostre", "Jörð" ]

  -- Verified with: https://planetcalc.com/1721/
  log "levenshtein" *> do
    assert $ String.levenshtein "CONSERVATIONALISTS" "CONVERSATIONALISTS" == 2
    assert $ String.levenshtein "WHIRLED" "WORLD" == 3
    assert $ String.levenshtein "COMPLEMENT" "COMPLIMENT" == 1
    assert $ String.levenshtein "BAZAAR" "BIZARRE" == 3
    assert $ String.levenshtein "ACCESSARY" "ACCESSORY" == 1
    assert $ String.levenshtein "ALGORITHMS ARE FUN" "LOGARITHMS ARE NOT" == 6
    assert $ String.levenshtein "ASSISTANCE" "ASSISTANTS" == 2
    assert $ String.levenshtein "ALL TOGETHER" "ALTOGETHER" == 2
    assert $ String.levenshtein "IDENTICAL STRINGS" "IDENTICAL STRINGS" == 0

  -- Verified with: http://www.algomation.com/algorithm/sorensen-dice-string-similarity
  log "sorensenDiceCoefficient" *> do
    assert $ normalizedCoefficient "CONSERVATIONALISTS" "CONVERSATIONALISTS" == (normalize 0.7647059)
    assert $ normalizedCoefficient "WHIRLED" "WORLD" == (normalize 0.2000000)
    assert $ normalizedCoefficient "COMPLEMENT" "COMPLIMENT" == (normalize 0.7777778)
    assert $ normalizedCoefficient "BAZAAR" "BIZARRE" == (normalize 0.36363637)
    assert $ normalizedCoefficient "ACCESSARY" "ACCESSORY" == (normalize 0.7500000)
    assert $ normalizedCoefficient "ALGORITHMS ARE FUN" "LOGARITHMS ARE NOT" == (normalize 0.5882353)
    assert $ normalizedCoefficient "ASSISTANCE" "ASSISTANTS" == (normalize 0.7777778)
    assert $ normalizedCoefficient "ALL TOGETHER" "ALTOGETHER" == (normalize 0.8000000)
    assert $ normalizedCoefficient "IDENTICAL STRINGS" "IDENTICAL STRINGS" == (normalize 1.0000000)

normalize :: Number -> Int
normalize n = Int.round (n * 100000.0)

normalizedCoefficient :: String -> String -> Int
normalizedCoefficient a b = normalize (String.sorensenDiceCoefficient a b)
