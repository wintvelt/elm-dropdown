{- a dropdown 
with open/ close state
and blur when clicked outside
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json
import Mouse exposing (Position)

import Styles.Styles as Styles

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
    { pickedCarBrand : Maybe CarBrand
    , isOpen : Bool
    }

-- simple types so we can read the code better
type alias CarBrand = String

-- global constants/ config
carBrands : List CarBrand
carBrands = 
    [ "Audi"
    , "BMW"
    , "Chevrolet"
    , "Ford"
    ]



init : ( Model, Cmd Msg )
init =
    { pickedCarBrand = Nothing
    , isOpen = False
    } ! []



-- UPDATE


type Msg
    = CarBrandPicked CarBrand
    | DropDownClicked
    | Blur Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    CarBrandPicked carBrand ->
        { model 
        | pickedCarBrand = Just carBrand 
        , isOpen = False
        } ! []

    DropDownClicked ->
        { model | isOpen = not model.isOpen } ! []

    Blur _ ->
        { model | isOpen = False } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.isOpen then
        Mouse.clicks Blur
    else
        Sub.none




-- VIEW



view : Model -> Html Msg
view model =
    let
        selectedText =
            model.pickedCarBrand
            |> Maybe.withDefault "-- pick a car brand --" 

        displayStyle =
            if model.isOpen then
                ("display", "block")
            else
                ("display", "none")

    in
        div [ style Styles.dropdownContainer ]
            [ p 
                [ style Styles.dropdownInput
                , onClick DropDownClicked 
                ] 
                [ span [ style Styles.dropdownText ] [ text <| selectedText ] 
                , span [] [ text " ▾" ]
                ]
            , ul 
                [ style <| displayStyle :: Styles.dropdownList ]
                (List.map viewCarBrand carBrands)
            ]

viewCarBrand : CarBrand -> Html Msg
viewCarBrand carBrand =
    li 
        [ style Styles.dropdownListItem
        , onClick <| CarBrandPicked carBrand 
        ]
        [ text carBrand ]


-- helper to cancel click anywhere
onClick : msg -> Attribute msg
onClick message =
    onWithOptions 
        "click" 
        { stopPropagation = True
        , preventDefault = False
        }
        (Json.succeed message)
