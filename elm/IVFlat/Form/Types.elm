module IVFlat.Form.Types exposing
  ( Finished
  , dripRate
  , allValues
  , isFormIncomplete

  -- exposed only for testing
  , Fields
  )

{- Types and simplish accessors related to the content of the form. 
-}

import IVFlat.Generic.Measures as Measure 
import IVFlat.Generic.ValidatedString exposing (ValidatedString)
import Tagged exposing (Tagged(Tagged))
import Maybe.Extra as Maybe


{- Similar to the `Obscured` types elsewhere, this describes those
`Model` fields code here can see. Private.
-}
type alias Fields model =
  { model
    | desiredDripRate : ValidatedString Measure.DropsPerSecond
    , desiredHours :    ValidatedString Measure.Hours
    , desiredMinutes :  ValidatedString Measure.Minutes
  }

{- When all the `Field` values exist and are valid, they can
be extracted to this structure. Client code therefore needn't worry
about how the fields have `Maybe` values.
-}
type alias Finished = 
  { dripRate : Measure.DropsPerSecond
  , hours :    Measure.Hours
  , minutes :  Measure.Minutes
  }

{- Extract just the `dripRate` field's value (which can be used before
the other fields are complete.
-}
dripRate : Fields model -> Maybe Measure.DropsPerSecond
dripRate model =
  model.desiredDripRate.value           

{- Convert fields with `Maybe` values into a single `Maybe
Finished` value.

Cross-field validations *are* performed. For example, the result will
be `Nothing` if both the `hours` and `minutes` fields are zero.

Note I'm relying on an the fact that every type alias (like `Finished`) 
for a record also creates a value constructor whose arguments
are in the same order as the fields are listed in the record. That's
iffy in general, since rearranging a record can break uses of the
constructor. However, it's safe in this case because each field has a
different type.
-}

allValues : Fields model -> Maybe Finished
allValues model =
  let
    extraction =
      Maybe.map3 Finished
        model.desiredDripRate.value
        model.desiredHours.value
        model.desiredMinutes.value
  in
    extraction 
      |> Maybe.andThen crossFieldValidations

{- Reject an (ostensibly) `FinishedForm` if both the hours and minutes
are zero
-}
crossFieldValidations : Finished -> Maybe Finished
crossFieldValidations model  = 
  case Measure.toMinutes model.hours model.minutes of
    (Tagged 0) -> Nothing
    _ -> Just model

{- True if either per-field or cross-field validations fail. 
-}             
isFormIncomplete : Fields model -> Bool      
isFormIncomplete model =
  allValues model |> Maybe.isNothing
