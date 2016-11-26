import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on)

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
    , focusedId : Maybe DomID
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
    , focusedId = Nothing
    }



-- UPDATE


type Msg
    = FruitPicked Fruit
    | Focused DomID


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    FruitPicked fruit ->
      { model | pickedFruit = fruit } ! []

    Focused domID ->
      model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW



view : Model -> Html Msg
view model =
    div []
        [ p [] [ text <| toString model.fruit ++ " ▾"] ]