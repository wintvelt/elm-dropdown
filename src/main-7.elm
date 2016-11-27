{- Part 7, where we add another dropdown
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
    , pickedQuantity : Maybe Quantity
    , focusedId : Maybe NodeID
    }

-- simple types so we can read the code better
type alias Fruit = String
type alias Quantity = String
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

quantities : List Quantity
quantities =
    [ "200 grams"
    , "500 grams"
    , "1 kilo"
    , "2 kilo"
    ]

fruitConfig : Dropdown6.Config Fruit Fruit Msg
fruitConfig  =
    { idFrom = identity
    , selectedText = Maybe.withDefault "- pick a fruit -"
    , nodeID = "dropdown"
    , focusMsg = FocusOn "dropdown"
    , itemMsg = FruitPicked
    , itemText = identity
    }

quantityConfig : Dropdown6.Config Quantity Quantity Msg
quantityConfig =
    { fruitConfig
    | selectedText = Maybe.withDefault "- pick a quantity -"
    , nodeID = "quantity"
    , focusMsg = FocusOn "quantity"
    , itemMsg = QuantityPicked
    }

init : ( Model, Cmd Msg )
init =
    { pickedFruit = Nothing
    , pickedQuantity = Nothing
    , focusedId = Nothing
    } ! []



-- UPDATE


type Msg
    = FruitPicked Fruit
    | QuantityPicked Quantity
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

    QuantityPicked quantity ->
        { model 
        | pickedQuantity = Just quantity 
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
    let
        isOpen nodeID =
            model.focusedId
            |> Maybe.map (\id -> id == nodeID) 
            |> Maybe.withDefault False
    in
        div []
            [ Dropdown6.view fruitConfig
                { data = assortment
                , isOpen = isOpen fruitConfig.nodeID
                , selected = model.pickedFruit
                }
            , Dropdown6.view quantityConfig
                { data = quantities
                , isOpen = isOpen quantityConfig.nodeID
                , selected = model.pickedQuantity
                }
            ]