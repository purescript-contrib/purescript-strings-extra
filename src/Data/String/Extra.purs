module Data.String.Extra
  ( camelCase
  , kebabCase
  , pascalCase
  , snakeCase
  , upperCaseFirst
  , words
  , levenshtein
  , sorensenDiceCoefficient
  ) where

import Data.Array as Array
import Data.Array.NonEmpty as NonEmptyArray
import Data.Char.Unicode as Unicode
import Data.Either (fromRight)
import Data.Foldable (foldMap)
import Data.String as String
import Data.String.CodeUnits as SCU
import Data.String.Regex (Regex)
import Data.String.Regex as Regex
import Data.String.Regex.Flags as Flags
import Partial.Unsafe (unsafePartial)
import Prelude ((>>>), (<>), map)

-- | Converts a `String` to camel case
-- | ```purescript
-- | camelCase "Hello world" == "helloWorld"
-- | ```
camelCase :: String -> String
camelCase =
  words >>> Array.uncons >>> foldMap \{ head, tail } ->
    toUnicodeLower head <> foldMap pascalCase tail

-- | Converts a `String` to kebab case
-- | ```purescript
-- | kebabCase "Hello world" == "hello-world"
-- | ```
kebabCase :: String -> String
kebabCase =
  words >>> map toUnicodeLower >>> String.joinWith "-"

-- | Converts a `String` to Pascal case
-- | ```purescript
-- | pascalCase "Hello world" == "HelloWorld"
-- | ```
pascalCase :: String -> String
pascalCase =
  words >>> foldMap upperCaseFirst

-- | Converts a `String` to snake case
-- | ```purescript
-- | snakeCase "Hello world" == "hello_world"
-- | ```
snakeCase :: String -> String
snakeCase =
  words >>> map toUnicodeLower >>> String.joinWith "_"

-- | Converts the first character in a `String` to upper case, lower-casing
-- | the rest of the string.
-- | ```purescript
-- | upperCaseFirst "hellO" == "Hello"
-- | ```
upperCaseFirst :: String -> String
upperCaseFirst =
  SCU.uncons >>> foldMap \{ head, tail } ->
    SCU.singleton (Unicode.toUpper head) <> toUnicodeLower tail

-- | Separates a `String` into words based on Unicode separators, capital
-- | letters, dashes, underscores, etc.
-- | ```purescript
-- | words "Hello_world --from TheAliens" == [ "Hello", "world", "from", "The", "Aliens" ]
-- | ```
words :: String -> Array String
words string =
  if hasUnicodeWords string then
    unicodeWords string
  else
    asciiWords string

-- | Calculates the levenshtein distance between two strings.
-- | ```purescript
-- | levenshtein "book" "back" -- 2
-- | ```
foreign import levenshtein :: String -> String -> Int

-- | Calculates the Sørensen-Dice coefficient between two strings.
-- | ```purescript
-- | sorensenDiceCoefficient "WHIRLED" "WORLD" -- 0.2000
-- | ```
foreign import sorensenDiceCoefficient :: String -> String -> Number


------------------------------------------------------------------------------

regexGlobal :: String -> Regex
regexGlobal regexStr =
  unsafePartial fromRight (Regex.regex regexStr Flags.global)

asciiWords :: String -> Array String
asciiWords =
  Regex.match (regexGlobal "[^\x00-\x2f\x3a-\x40\x5b-\x60\x7b-\x7f]+")
    >>> foldMap NonEmptyArray.catMaybes

hasUnicodeWords :: String -> Boolean
hasUnicodeWords =
  Regex.test (regexGlobal "[a-z][A-Z]|[A-Z]{2,}[a-z]|[0-9][a-zA-Z]|[a-zA-Z][0-9]|[^a-zA-Z0-9]")

toUnicodeLower :: String -> String
toUnicodeLower =
  SCU.toCharArray >>> map Unicode.toLower >>> SCU.fromCharArray

toUnicodeUpper :: String -> String
toUnicodeUpper =
  SCU.toCharArray >>> map Unicode.toUpper >>> SCU.fromCharArray

unicodeWords :: String -> Array String
unicodeWords =
  Regex.match (regexGlobal regexStr) >>> foldMap NonEmptyArray.catMaybes
  where
    -- https://github.com/lodash/lodash/blob/master/.internal/unicodeWords.js
    -- Used to compose unicode character classes.
    rsAstralRange = "\\ud800-\\udfff"
    rsComboMarksRange = "\\u0300-\\u036f"
    reComboHalfMarksRange = "\\ufe20-\\ufe2f"
    rsComboSymbolsRange = "\\u20d0-\\u20ff"
    rsComboRange = rsComboMarksRange <> reComboHalfMarksRange <> rsComboSymbolsRange
    rsDingbatRange = "\\u2700-\\u27bf"
    rsLowerRange = "a-z\\xdf-\\xf6\\xf8-\\xff"
    rsMathOpRange = "\\xac\\xb1\\xd7\\xf7"
    rsNonCharRange = "\\x00-\\x2f\\x3a-\\x40\\x5b-\\x60\\x7b-\\xbf"
    rsPunctuationRange = "\\u2000-\\u206f"
    rsSpaceRange = " \\t\\x0b\\f\\xa0\\ufeff\\n\\r\\u2028\\u2029\\u1680\\u180e\\u2000\\u2001\\u2002\\u2003\\u2004\\u2005\\u2006\\u2007\\u2008\\u2009\\u200a\\u202f\\u205f\\u3000"
    rsUpperRange = "A-Z\\xc0-\\xd6\\xd8-\\xde"
    rsVarRange = "\\ufe0e\\ufe0f"
    rsBreakRange = rsMathOpRange <> rsNonCharRange <> rsPunctuationRange <> rsSpaceRange

    -- Used to compose unicode capture groups.
    rsApos = "['\\u2019]"
    rsBreak = "[" <> rsBreakRange <> "]"
    rsCombo = "[" <> rsComboRange <> "]"
    rsDigits = "\\d+"
    rsDingbat = "[" <> rsDingbatRange <> "]"
    rsLower = "[" <> rsLowerRange <> "]"
    rsMisc = "[^" <> rsAstralRange <> rsBreakRange <> rsDigits <> rsDingbatRange <> rsLowerRange <> rsUpperRange <> "]"
    rsFitz = "\\ud83c[\\udffb-\\udfff]"
    rsModifier = "(?:" <> rsCombo <> "|" <> "rsFitz)"
    rsNonAstral = "[^" <> rsAstralRange <> "]"
    rsRegional = "(?:\\ud83c[\\udde6-\\uddff]){2}"
    rsSurrPair = "[\\ud800-\\udbff][\\udc00-\\udfff]"
    rsUpper = "[" <> rsUpperRange <> "]"
    rsZWJ = "\\u200d"

    -- Used to compose unicode regexes.
    rsMiscLower = "(?:" <> rsLower <> "|" <> rsMisc <> ")"
    rsMiscUpper = "(?:" <> rsUpper <> "|" <> rsMisc <> ")"
    rsOptContrLower = "(?:" <> rsApos <> "(?:d|ll|m|re|s|t|ve))?"
    rsOptContrUpper = "(?:" <> rsApos <> "(?:D|LL|M|RE|S|T|VE))?"
    reOptMod = rsModifier <> "?"
    rsOptVar = "[" <> rsVarRange <> "]?"
    rsOptJoin = "(?:" <> rsZWJ <> "(?:" <> rsNonAstral <> "|" <> rsRegional <> "|" <> rsSurrPair <> ")" <> rsOptVar <> reOptMod <> ")*"
    rsOrdLower = "\\d*(?:(?:1st|2nd|3rd|(?![123])\\dth)\\b)"
    rsOrdUpper = "\\d*(?:(?:1ST|2ND|3RD|(?![123])\\dTH)\\b)"
    rsSeq = rsOptVar <> reOptMod <> rsOptJoin
    rsEmoji = "(?:" <> rsDingbat <> "|" <> rsRegional <> "|" <> rsSurrPair <> ")" <> rsSeq

    -- Put it all together
    regexStr :: String
    regexStr =
      String.joinWith "|"
        [ rsUpper <> "?" <> rsLower <> "+" <> rsOptContrLower <> "(?=" <> rsBreak <> "|" <> rsUpper <> "|$)"
        , rsMiscUpper <> "+" <> rsOptContrUpper <> "(?=" <> rsBreak <> "|" <> rsUpper <> rsMiscLower <> "|$)"
        , rsUpper <> "?" <> rsMiscLower <> "+" <> rsOptContrLower
        , rsUpper <> "+" <> rsOptContrUpper
        , rsOrdUpper
        , rsOrdLower
        , rsDigits
        , rsEmoji
        ]
