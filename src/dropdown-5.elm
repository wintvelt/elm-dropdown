{- Part 5, a simple dropdown with focus
and subscription to Mouse.clicks to close the dropdown
with some additional styling
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Mouse exposing (Position)

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


-- styles for main container
mainContainerStyles : List (String, String)
mainContainerStyles =
    [ ("position","relative")
    , ("margin","16px")
    , ("width", "200px")
    , ("display", "inline-block")
    ]

-- styles for main input field
mainStyles : List (String, String)
mainStyles =
    [ ("padding","7px 0 6px 16px")
    , ("width", "200px")
    , ("margin","0")
    ]

-- styles for list container
menuStyles : List (String, String)
menuStyles =
    [ ("position", "absolute")
    , ("top", "0")
    , ("border-radius","4px")
    , ("box-shadow", "0 1px 2px rgba(0,0,0,.24)")
    , ("padding", "4px 8px")
    , ("margin", "0")
    , ("width", "200px")
    , ("background-color", "white")
    ]

-- styles for list items
itemStyles : List (String, String)
itemStyles =
    [ ("display", "block")
    , ("padding","4px 8px")
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
            displayStyle :: menuStyles

    in
        div [ style mainContainerStyles ]
            [ p [ onClick <| FocusOn "myDropdown" 
                , style mainStyles
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
                        :: itemStyles
                    else
                        itemStyles

                Nothing ->
                    itemStyles
    in
        li 
            [ style fruitStyles
            , onClick <| FruitPicked fruit 
            ]
            [ text fruit ]