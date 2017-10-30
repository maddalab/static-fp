module Lens.Motivation.Restructured.TagDb exposing
  ( TagDb
  , empty
  , idTags
  , tagIds
  , addAnimal
  , addTag
  )

import Lens.Motivation.Restructured.TestAccess.TagDb as Support

import Lens.Motivation.Restructured.Animal as Animal
import Lens.Try3.Lens as Lens
import Dict exposing (Dict)
import Array exposing (Array)


type alias TagDb = Support.TagDb

empty : TagDb  
empty =
  { allTags = Dict.empty
  , allIds = Dict.empty
  }

addAnimal : Animal.Id -> List String -> TagDb -> TagDb
addAnimal id tags db =
  let
    withId =
      Lens.set (Support.idTags_upsert id) (Just Array.empty) db
  in
    List.foldl (addTag id) withId tags
  

addTag : Animal.Id -> String -> TagDb -> TagDb
addTag id tag db = 
    db
      |> updateIdTags id (Array.push tag)
      |> updateTagIds tag (Array.push id)

--- Exported lenses (not all should be public)

idTags : Animal.Id -> Lens.Humble TagDb (Array String)
idTags = Support.idTags

tagIds : String -> Lens.Humble TagDb (Array Animal.Id)
tagIds = Support.tagIds


--- Helpers

type alias StringsMapper = Array String -> Array String
type alias IdsMapper = Array Animal.Id -> Array Animal.Id

updateIdTags : Animal.Id -> StringsMapper -> TagDb -> TagDb
updateIdTags id = 
  Lens.update (idTags id)

updateTagIds: String -> IdsMapper -> TagDb -> TagDb
updateTagIds tag =
  Lens.updateWithDefault (Support.tagIds_upsert tag) Array.empty

    
         