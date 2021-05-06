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
import Data.String.Unicode as Unicode
import Data.CodePoint.Unicode as UCP
import Data.Foldable (foldMap)
import Data.String as String
import Data.String.CodePoints as SCP
import Data.String.Regex (Regex)
import Data.String.Regex as Regex
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.String.Regex.Flags as Flags
import Prelude ((>>>), (<>), ($), map)

-- | Converts a `String` to camel case
-- |
-- | ```purs
-- | camelCase "Hello world" == "helloWorld"
-- | ```
camelCase :: String -> String
camelCase =
  words >>> Array.uncons >>> foldMap \{ head, tail } ->
    Unicode.toLower head <> foldMap pascalCase tail

-- | Converts a `String` to kebab case
-- |
-- | ```purs
-- | kebabCase "Hello world" == "hello-world"
-- | ```
kebabCase :: String -> String
kebabCase =
  words >>> map Unicode.toLower >>> String.joinWith "-"

-- | Converts a `String` to Pascal case
-- |
-- | ```purs
-- | pascalCase "Hello world" == "HelloWorld"
-- | ```
pascalCase :: String -> String
pascalCase =
  words >>> foldMap upperCaseFirst

-- | Converts a `String` to snake case
-- |
-- | ```purs
-- | snakeCase "Hello world" == "hello_world"
-- | ```
snakeCase :: String -> String
snakeCase =
  words >>> map Unicode.toLower >>> String.joinWith "_"

-- | Converts the first character in a `String` to upper case, lower-casing
-- | the rest of the string.
-- |
-- | ```purs
-- | upperCaseFirst "hello World" == "Hello world"
-- | ```
upperCaseFirst :: String -> String
upperCaseFirst =
  SCP.uncons >>> foldMap \{ head, tail } ->
    SCP.fromCodePointArray (UCP.toTitle head) <> Unicode.toLower tail

-- | Separates a `String` into words based on Unicode separators, capital
-- | letters, dashes, underscores, etc.
-- |
-- | ```purs
-- | words "Hello_world --from TheAliens" == [ "Hello", "world", "from", "The", "Aliens" ]
-- | ```
words :: String -> Array String
words string =
  if hasUnicodeWords string then
    unicodeWords string
  else
    asciiWords string

-- | Calculates the Levenshtein distance between two strings.
-- |
-- | ```purs
-- | levenshtein "book" "back" -- 2
-- | ```
foreign import levenshtein :: String -> String -> Int

-- | Calculates the Sørensen-Dice coefficient between two strings.
-- |
-- | ```purs
-- | sorensenDiceCoefficient "WHIRLED" "WORLD" -- 0.2000
-- | ```
foreign import sorensenDiceCoefficient :: String -> String -> Number

------------------------------------------------------------------------------

regexGlobal :: String -> Regex
regexGlobal regexStr =
  unsafeRegex regexStr Flags.global

regexHasASCIIWords :: Regex
regexHasASCIIWords =
  regexGlobal "[^\x00-\x2f\x3a-\x40\x5b-\x60\x7b-\x7f]+"

asciiWords :: String -> Array String
asciiWords =
  Regex.match regexHasASCIIWords >>> foldMap NonEmptyArray.catMaybes

regexHasUnicodeWords :: Regex
regexHasUnicodeWords =
  regexGlobal "[a-z][A-Z]|[A-Z]{2,}[a-z]|[0-9][a-zA-Z]|[a-zA-Z][0-9]|[^a-zA-Z0-9]"

hasUnicodeWords :: String -> Boolean
hasUnicodeWords =
  Regex.test regexHasUnicodeWords

regexUnicodeWords :: Regex
regexUnicodeWords =
  regexGlobal
    $ String.joinWith "|"
        [ rsUpper <> "?" <> rsLower <> "+" <> rsOptContrLower <> "(?=" <> rsBreak <> "|" <> rsUpper <> "|$)"
        , rsMiscUpper <> "+" <> rsOptContrUpper <> "(?=" <> rsBreak <> "|" <> rsUpper <> rsMiscLower <> "|$)"
        , rsUpper <> "?" <> rsMiscLower <> "+" <> rsOptContrLower
        , rsUpper <> "+" <> rsOptContrUpper
        , rsOrdUpper
        , rsOrdLower
        , rsDigit <> "+"
        , rsEmoji
        ]
  where
  -- https://github.com/lodash/lodash/blob/master/.internal/unicodeWords.js
  -- Used to compose unicode character classes.
  rsAstralRange = "\\ud800-\\udfff"
  rsComboMarksRange = "\\u0300-\\u036f"
  reComboHalfMarksRange = "\\ufe20-\\ufe2f"
  rsComboSymbolsRange = "\\u20d0-\\u20ff"
  rsComboMarksExtendedRange = "\\u1ab0-\\u1aff"
  rsComboMarksSupplementRange = "\\u1dc0-\\u1dff"
  rsComboRange = rsComboMarksRange <> reComboHalfMarksRange <> rsComboSymbolsRange <> rsComboMarksExtendedRange <> rsComboMarksSupplementRange
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
  rsDigit = "\\d"
  rsDingbat = "[" <> rsDingbatRange <> "]"
  rsLower = "[" <> rsLowerRange <> "]"
  rsMisc = "[^" <> rsAstralRange <> rsBreakRange <> rsDigit <> rsDingbatRange <> rsLowerRange <> rsUpperRange <> "]"
  rsFitz = "\\ud83c[\\udffb-\\udfff]"
  rsModifier = "(?:" <> rsCombo <> "|" <> rsFitz <> ")"
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
  rsOrdLower = "\\d*(?:1st|2nd|3rd|(?![123])\\dth)(?=\\b|[A-Z_])"
  rsOrdUpper = "\\d*(?:1ST|2ND|3RD|(?![123])\\dTH)(?=\\b|[a-z_])"
  rsSeq = rsOptVar <> reOptMod <> rsOptJoin
  rsEmoji = "(?:" <> rsDingbat <> "|" <> rsRegional <> "|" <> rsSurrPair <> ")" <> rsSeq

unicodeWords :: String -> Array String
unicodeWords =
  Regex.match regexUnicodeWords >>> foldMap NonEmptyArray.catMaybes
