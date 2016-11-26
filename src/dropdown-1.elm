{- Part 1, a simple picklist
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

-- our main model, which will change as we use the app
type alias Model =
    { pickedFruit : Maybe Fruit
    }

-- simple types so we can read the code better
type alias Fruit = String
type alias DomID = String

-- global constants/ config
assortment : List String
assortment = 
    [ "Apple"
    , "Banana"
    , "Cherry"
    , "Durian"
    , "Elderberry"
    ]



init : ( Model, Cmd Msg )
init =
    { pickedFruit = Nothing
    } ! []



-- UPDATE


type Msg
    = FruitPicked Fruit


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    FruitPicked fruit ->
      { model | pickedFruit = Just fruit } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW



view : Model -> Html Msg
view model =
    let
        itemText =
            model.pickedFruit
            |> Maybe.withDefault "-- pick a fruit --" 
            |> flip String.append " ▾"

    in
        div []
            [ p [] [ text <| itemText ] 
            , ul []
                (List.map viewFruit assortment)
            ]

viewFruit : Fruit -> Html Msg
viewFruit fruit =
    li [ onClick <| FruitPicked fruit ]
        [ text fruit ]