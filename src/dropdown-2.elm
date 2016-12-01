{- a simple dropdown with open/ close state
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Styles

main =
  Html.beginnerProgram
    { model = init
    , view = view
    , update = update
    }


-- MODEL

-- our main model, which will change as we use the app
type alias Model =
    { pickedCarBrand : Maybe CarBrand
    , isOpen : DropDownState
    }

-- simple types so we can read the code better
type alias CarBrand = String
type DropDownState = Open | Closed

-- global constants/ config
carBrands : List String
carBrands = 
    [ "Audi"
    , "BMW"
    , "Chevrolet"
    , "Daimler"
    , "Ford"
    ]



init : Model
init =
    { pickedCarBrand = Nothing
    , isOpen = Closed
    }



-- UPDATE


type Msg
    = CarBrandPicked CarBrand
    | DropDownClicked


update : Msg -> Model -> Model
update msg model =
  case msg of
    CarBrandPicked carBrand ->
        { model 
        | pickedCarBrand = Just carBrand 
        , isOpen = Closed
        }

    DropDownClicked ->
        { model | isOpen = Open }




-- VIEW



view : Model -> Html Msg
view model =
    let
        selectedText =
            model.pickedCarBrand
            |> Maybe.withDefault "-- pick a car brand --" 

        displayStyle =
            case model.isOpen of
                Open ->
                    ("display", "block")

                Closed ->
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