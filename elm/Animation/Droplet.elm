module Animation.Droplet exposing (..)

import Html as H exposing (Html)
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation.Common as C exposing (Msg(..))
import Animation

type alias Model =
  { droplet : C.AnimationModel
  }

init : (Model, Cmd Msg)
init = ({ droplet =
            Animation.style
              [ Animation.x 200
              , Animation.y 10
              ]
        }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model |
            droplet = 
              Animation.interrupt
                [ Animation.to
                    [ Animation.x 200
                    , Animation.y 300
                    ]
                ]
                model.droplet
        }
      , Cmd.none
      )
    Tick animationMsg ->
      let
        newStyle = Animation.update animationMsg model.droplet
      in
        ( { model | droplet = newStyle }
        , Cmd.none
        )


view : Model -> Html Msg
view model =
  C.wrapper
    [ C.canvas
        [ S.rect
            ([ SA.height "20"
             , SA.width "20"
             , SA.fill "grey"
             ] ++ Animation.render model.droplet)
            []
        ]
    , C.button Start "Click Me"
    ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick [ model.droplet ]

    
main : Program Never Model Msg
main =
  H.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    
