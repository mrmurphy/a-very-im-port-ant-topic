port module Main exposing (..)

import Color exposing (red, rgb, rgba)
import Date exposing (Date)
import Element exposing (above, button, column, el, empty, header, html, image, layout, onLeft, row, text, textArea)
import Element.Attributes exposing (alignBottom, center, contenteditable, fill, height, justify, maxHeight, maxWidth, padding, paddingLeft, paddingRight, paddingTop, percent, px, spacing, vary, verticalCenter, width)
import Element.Events exposing (on, onClick, onInput, onMouseUp)
import Entry exposing (Entry)
import Html exposing (Html)
import OutsideInfo exposing (..)
import Style exposing (hover, opacity, paddingRightHint, prop, style, styleSheet, variation)
import Style.Border exposing (rounded)
import Style.Color exposing (background, border)
import Style.Font exposing (lineHeight, typeface)
import Style.Transition
import Time exposing (Time, second)


---- MODEL ----


type alias Model =
    { entries : List Entry
    , editingIds : List Int
    , now : Date
    }


init : ( Model, Cmd Msg )
init =
    ( { entries = []
      , editingIds = []
      , now = Date.fromTime 0
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | Outside InfoForElm
    | LogErr String
    | ToggleEntryEdit Int
    | SetNow Time
    | AddEntry
    | UpdateEntry Entry
    | DeleteEntry Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Outside infoForElm ->
            case infoForElm of
                EntriesChanged newEntries ->
                    { model | entries = newEntries }
                        ! []

        LogErr err ->
            model ! [ sendInfoOutside (ErrorLogRequested err) ]

        ToggleEntryEdit id ->
            let
                alreadyHasId =
                    List.any ((==) id) model.editingIds
            in
            { model
                | editingIds =
                    if alreadyHasId then
                        List.filter ((/=) id) model.editingIds
                    else
                        id :: model.editingIds
            }
                ! []

        SetNow time ->
            { model | now = Date.fromTime time } ! []

        AddEntry ->
            model
                ! [ sendInfoOutside EntryCreationRequested ]

        UpdateEntry entry ->
            model
                ! [ sendInfoOutside <| EntryModified entry ]

        DeleteEntry id_ ->
            model ! [ sendInfoOutside (EntryDeleted id_) ]



---- VIEW ----


type Styles
    = NoStyle
    | TitleBar
    | LogoImg
    | HeaderBG
    | EntryDate
    | EntryContent
    | Root
    | ContentInput
    | CreateEntryButton
    | DeleteButton


type Variation
    = Editing


sheet : Style.StyleSheet Styles Variation
sheet =
    styleSheet
        [ style NoStyle []
        , style Root
            [ Style.Font.typeface [ "Bitter" ]
            , lineHeight 1.7
            , Style.Font.size 16
            , background (rgb 244 241 237)
            , Style.Color.text (rgb 114 103 89)
            ]
        , style TitleBar
            [ Style.Color.text (rgb 242 243 238)
            , Style.Font.size 18
            ]
        , style HeaderBG
            [ background (rgb 133 118 100)
            ]
        , style EntryDate
            [ Style.Font.size 30
            , Style.Font.bold
            , typeface [ "Alegreya" ]
            ]
        , style EntryContent
            [ variation Editing
                [ background (rgb 255 255 255)
                , border (rgb 226 221 216)
                , Style.Border.all 2
                , rounded 3
                ]
            ]
        , style ContentInput
            [ Style.Border.none
            , background (rgba 0 0 0 0)
            , Style.Border.bottom 1
            , border (rgb 194 170 152)
            ]
        , style CreateEntryButton
            [ background (rgba 0 0 0 0)
            , Style.Border.none
            ]
        , style DeleteButton
            [ Style.Font.size 15
            , opacity 0.1
            , Style.Border.none
            , background <| rgba 0 0 0 0
            , Style.Transition.all
            , hover
                [ Style.Color.text (rgb 207 84 82), opacity 1 ]
            ]
        ]


titleBar : Element.Element Styles Variation Msg
titleBar =
    column HeaderBG
        [ padding 40, spacing 40 ]
        [ image "pocket-journal.png"
            NoStyle
            [ width (px 518), center ]
            empty
        , button <|
            el CreateEntryButton
                [ verticalCenter
                , width (fill 1)
                , padding 10
                , onClick AddEntry
                ]
            <|
                image "create-entry.png"
                    NoStyle
                    [ width (px 292), center ]
                    empty
        ]


entryListView : Model -> Element.Element Styles Variation Msg
entryListView model =
    column NoStyle [ maxWidth (px 600), padding 10, center ] <|
        List.map
            (\entry ->
                entryView entry
                    (List.any ((==) entry.id) model.editingIds)
            )
        <|
            List.reverse <|
                List.sortBy (\a -> Date.toTime a.date) model.entries


entryView : Entry -> Bool -> Element.Element Styles Variation Msg
entryView entry isEditing =
    column NoStyle
        [ padding 10, spacing 10, width (fill 1) ]
        [ row EntryDate
            [ contenteditable False, spacing 20 ]
            [ text (dateView entry.date)
            , button <|
                el DeleteButton
                    [ onClick <| ToggleEntryEdit entry.id ]
                <|
                    text "✍"
            , button <|
                el DeleteButton
                    [ onClick <| DeleteEntry entry.id ]
                <|
                    text "✖"
            ]
        , el EntryContent
            [ vary Editing isEditing ]
          <|
            case isEditing of
                True ->
                    textArea NoStyle
                        [ width (fill 1)
                        , padding 10
                        , height (px 250)
                        , onInput (\val -> UpdateEntry { entry | content = val })
                        ]
                        entry.content

                False ->
                    text entry.content
        ]


dateView : Date -> String
dateView date =
    "The " ++ (toString <| Date.day date) ++ " of " ++ (toString <| Date.month date) ++ ", " ++ (toString <| Date.year date)


view : Model -> Html Msg
view model =
    layout sheet <|
        column Root
            []
            [ titleBar

            -- , formView model
            , entryListView model
            ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions =
            \model ->
                Sub.batch
                    [ Time.every second SetNow
                    , getInfoFromOutside Outside LogErr
                    ]
        }
