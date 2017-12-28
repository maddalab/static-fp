module Errors.Simple.Model exposing
  ( Model
  , init

  , clickCount
  , beloved
  , word
  , wordCount
  )

import Errors.Simple.Word as Word exposing (Word)

import Lens.Try4.Lens as Lens 
import Lens.Try4.Compose.Operators exposing (..)
import Dict exposing (Dict)
import Array exposing (Array)
import Lens.Try4.Dict as Dict
import Lens.Try4.Array as Array


{- Model -}
    
type alias Model =
  { words : Dict String (Array Word)
  , beloved : String
  , clickCount : Int
  }

  
init : (Model, Cmd msg)
init =
  ( { words = Dict.singleton "Dawn" (Array.fromList Word.all)
    , beloved = "Dawn"
    , clickCount = 0
    }
  , Cmd.none
  )


{- Lenses -}

clickCount : Lens.Classic Model Int
clickCount =
  Lens.classic .clickCount (\clickCount model -> { model | clickCount = clickCount })

beloved : Lens.Classic Model String
beloved =
  Lens.classic .beloved (\beloved model -> { model | beloved = beloved })
    
words : Lens.Classic Model (Dict String (Array Word))
words =
  Lens.classic .words (\words model -> { model | words = words })

word : String -> Int -> Lens.Humble Model Word
word who index =
  words .?>> Dict.humbleLens who ??>> Array.lens index

wordCount : String -> Int -> Lens.Humble Model Int
wordCount who index =
  word who index ?.>> Word.count
