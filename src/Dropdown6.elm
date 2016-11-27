module Dropdown6 exposing (..)
{- Part 6, where we extract the dropdown from main
This is a simple dropdown with focus
and subscription to Mouse.clicks to close the dropdown
with some additional styling, imported from separate module
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Styles


-- CONFIG
-- the static stuff, that does not change during the apps lifecycle
type alias Config a id msg =
    { idFrom : (a -> id)
    , selectedText : (Maybe id -> String)
    , nodeID : NodeID
    , focusMsg : (NodeID -> msg)
    , itemMsg : (a -> msg)
    , itemText : (a -> String)
    }

-- DATA
-- the dynamic stuff the view
type alias Data a id =
    { data : List a
    , selected : Maybe id
    , isOpen : Bool
    }


-- simple types so we can read the code better
type alias NodeID = String


-- VIEW



view : Config a id msg -> Data a id -> Html msg
view config data =
    let
        itemText =
            config.selectedText data.selected
            |> flip String.append " ▾"

        displayStyle =
            if data.isOpen then
                ("display", "block")
            else
                ("display", "none")

        ulStyles = 
            displayStyle :: Styles.dropdownList

    in
        div [ style Styles.dropdownContainer ]
            [ p [ onClick <| config.focusMsg config.nodeID
                , style Styles.dropdownInput
                ] 
                [ text <| itemText ] 
            , ul [ style ulStyles ]
                (List.map (viewItem config data.selected) data.data)
            ]

viewItem : Config a id msg -> Maybe id -> a -> Html msg
viewItem config maybeSelected item =
    let
        itemStyles =
            case maybeSelected of
                Just selected ->
                    if selected == config.idFrom item then
                        ("background-color","rgba(50,100,200,.27)")
                        :: Styles.dropdownListItem
                    else
                        Styles.dropdownListItem

                Nothing ->
                    Styles.dropdownListItem
    in
        li 
            [ style itemStyles
            , onClick (config.itemMsg item)
            ]
            [ text <| config.itemText item ]