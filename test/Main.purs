module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Exception (catchException, message, name, throw)
import Test.Assert (assertEqual)

main :: Effect Unit
main = do
  result <- throw "test" # catchException \err -> do
    assertEqual
      { actual: message err
      , expected: "test"
      }
    assertEqual
      { actual: name err
      , expected: "error"
      }
    pure "done"
  assertEqual { actual: result, expected: "done" }
