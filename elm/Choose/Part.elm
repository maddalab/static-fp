module Choose.Part exposing
  ( Part, Lens
  , make
  , get, set, update
  , append, next
  )

type alias Getter big small =          big -> small
type alias Setter big small = small -> big -> big

type alias Part big small =
  { get : Getter big small
  , set : Setter big small
  }
type alias Lens big small = Part big small  

make : Getter big small -> Setter big small -> Part big small
make getter setter =
  { get = getter, set = setter}
  

get : Part big small -> Getter big small
get chooser = chooser.get

set : Part big small -> Setter big small
set chooser = chooser.set

update : Part big small -> (small -> small) -> big -> big
update chooser f big =
  big
    |> chooser.get
    |> f
    |> flip chooser.set big
          

append : Part a b -> Part b c -> Part a c
append a2b b2c =
  let 
    get =
      a2b.get >> b2c.get
        
    set c =
      update a2b (b2c.set c)
      -- let
      --   b = a2b.get a
      -- in
      --   a |> a2b.set (b2c.set c b)

  in
    make get set

-- Add the first chooser to the second. Intended to be pipelined       
next : Part b c -> Part a b -> Part a c
next = flip append
