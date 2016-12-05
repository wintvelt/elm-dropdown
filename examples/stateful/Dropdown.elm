module Stateful.Dropdown exposing 
    (Context, Model, init, selectedFrom, openState, Msg(..), update, view)
{- a Dropdown component that manages its own state
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json

import Styles.Styles as Styles



-- MODEL

{- main model, opaque to ensure it can only be updated thru Msg and Update
-}
type Model =
    Model
        { selectedItem : Maybe String
        , isOpen : Bool
        }


init : Model
init =
    Model
        { selectedItem = Nothing
        , isOpen = False
        }

{- Context type alias
(this is stuff not managed by the dropdown, but passed in from parent)
kind of like props (including callbacks) in react
in our dropdown context is the default text, displayed if no item is selected
-} 
type alias Context = String

-- helpers to enable reading from Model
selectedFrom : Model -> Maybe String
selectedFrom (Model {selectedItem}) =
    selectedItem

openState : Model -> Bool
openState (Model {isOpen}) =
    isOpen




-- UPDATE


type Msg
    = ItemPicked (Maybe String)
    | SetOpenState Bool


update : Msg -> Model -> ( Model, Maybe String )
update msg (Model model) =
  case msg of
    ItemPicked item ->
        ( Model
            { model 
            | selectedItem = item
            , isOpen = False
            }
        , item
        )

    SetOpenState newState ->
        ( Model
            { model 
            | isOpen = newState
            }
        , Nothing
        )




-- VIEW



view : Context -> Model -> List String -> Html Msg
view context (Model model) data =
    let
        mainText =
            model.selectedItem
            |> Maybe.withDefault context

        displayStyle =
            if model.isOpen then
                ("display", "block")
            else
                ("display", "none")

        mainAttr =
            case data of
                [] -> 
                    [ style <| Styles.dropdownDisabled ++ Styles.dropdownInput
                    ] 

                _ ->
                    [ style Styles.dropdownInput
                    , onClick <| SetOpenState <| not model.isOpen 
                    ] 

    in
        div 
            [ style Styles.dropdownContainer ]
            [ p 
                mainAttr
                [ span [ style Styles.dropdownText ] [ text mainText ] 
                , span [] [ text "▾" ]
                ]
            , ul 
                [ style <| displayStyle :: Styles.dropdownList ]
                (List.map viewItem data)
            ]
            
    
viewItem : String -> Html Msg
viewItem item =
    li 
        [ style Styles.dropdownListItem
        , onClick <| ItemPicked <| Just item 
        ]
        [ text item ]


-- helper to cancel click anywhere
onClick : msg -> Attribute msg
onClick message =
    onWithOptions 
        "click" 
        { stopPropagation = True
        , preventDefault = False
        }
        (Json.succeed message)
