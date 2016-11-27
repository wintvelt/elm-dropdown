{- Part 6, where we extract the dropdown view
and subscription to Mouse.clicks to close the dropdown
with some additional styling, imported from separate module
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Mouse exposing (Position)

import Dropdown6 exposing (..)

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
    , focusedId : Maybe NodeID
    }

-- simple types so we can read the code better
type alias Fruit = String
type alias NodeID = String

-- global constants/ config
assortment : List Fruit
assortment = 
    [ "Apple"
    , "Banana"
    , "Cherry"
    , "Durian"
    , "Elderberry"
    ]

dropdownConfig : Dropdown6.Config Fruit Fruit Msg
dropdownConfig  =
    { idFrom = identity
    , selectedText = Maybe.withDefault "- pick a fruit -"
    , nodeID = "dropdown"
    , focusMsg = FocusOn "dropdown"
    , itemMsg = FruitPicked
    , itemText = identity
    }


init : ( Model, Cmd Msg )
init =
    { pickedFruit = Nothing
    , focusedId = Nothing
    } ! []



-- UPDATE


type Msg
    = FruitPicked Fruit
    | FocusOn NodeID
    | Blur Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    FruitPicked fruit ->
        { model 
        | pickedFruit = Just fruit 
        , focusedId = Nothing
        } ! []

    FocusOn nodeID ->
        { model | focusedId = Just nodeID } ! []


    Blur _ ->
        { model | focusedId = Nothing } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  case model.focusedId of
    Just _ ->
        Mouse.clicks Blur

    Nothing ->
        Sub.none



-- VIEW



view : Model -> Html Msg
view model =
    Dropdown6.view dropdownConfig
        { data = assortment
        , isOpen = 
            model.focusedId 
            |> Maybe.map (\id -> id == dropdownConfig.nodeID) 
            |> Maybe.withDefault False
        , selected = model.pickedFruit
        }