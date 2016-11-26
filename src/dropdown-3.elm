{- Part 2, a simple picklist with focus
This time menu is hidden when item is clicked
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

        displayStyle =
            case model.focusedId of
                Just "myDropdown" ->
                    style [("display", "block")]

                _ ->
                    style [("display", "none")]

    in
        div []
            [ p [ onClick <| FocusOn "myDropdown" ] 
                [ text <| itemText ] 
            , ul [ displayStyle ]
                (List.map viewFruit assortment)
            ]

viewFruit : Fruit -> Html Msg
viewFruit fruit =
    li [ onClick <| FruitPicked fruit ]
        [ text fruit ]