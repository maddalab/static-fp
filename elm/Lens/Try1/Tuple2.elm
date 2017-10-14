module Lens.Try1.Tuple2 exposing
  ( first
  , second
  )

import Lens.Try1.Lens as Lens exposing (Lens, lens)

first : Lens (focus, a) focus
first =
  lens
    (\ (first, _) -> first)
    (\ first (_, second) -> (first, second))
      
second : Lens (a, focus) focus
second =
  lens
    (\ (_, second) -> second)
    (\ second (first, _) -> (first, second))
