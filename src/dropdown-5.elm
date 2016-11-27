{- Part 5, a simple dropdown with focus
and subscription to Mouse.clicks to close the dropdown
with some additional styling, imported from separate module
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Mouse exposing (Position)

import Styles

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
    let
        itemText =
            model.pickedFruit
            |> Maybe.withDefault "-- pick a fruit --" 
            |> flip String.append " ▾"

        displayStyle =
            case model.focusedId of
                Just "myDropdown" ->
                    ("display", "block")

                _ ->
                    ("display", "none")

        ulStyles = 
            displayStyle :: Styles.dropdownList

    in
        div [ style Styles.dropdownContainer ]
            [ p [ onClick <| FocusOn "myDropdown" 
                , style Styles.dropdownInput
                ] 
                [ text <| itemText ] 
            , ul [ style ulStyles ]
                (List.map (viewFruit model.pickedFruit) assortment)
            ]

viewFruit : Maybe Fruit -> Fruit -> Html Msg
viewFruit maybeSelected fruit =
    let
        fruitStyles =
            case maybeSelected of
                Just selected ->
                    if selected == fruit then
                        ("background-color","rgba(50,100,200,.27)")
                        :: Styles.dropdownListItem
                    else
                        Styles.dropdownListItem

                Nothing ->
                    Styles.dropdownListItem
    in
        li 
            [ style fruitStyles
            , onClick <| FruitPicked fruit 
            ]
            [ text fruit ]