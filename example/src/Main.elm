port module Main exposing (..)

import Color exposing (red, rgb, rgba)
import Date exposing (Date)
import Element exposing (above, button, column, el, empty, header, html, image, layout, onLeft, row, text, textArea)
import Element.Attributes exposing (alignBottom, center, contenteditable, fill, height, justify, maxHeight, maxWidth, padding, paddingLeft, paddingRight, paddingTop, percent, px, spacing, vary, verticalCenter, width)
import Element.Events exposing (on, onClick, onInput, onMouseUp)
import Html exposing (Html)
import Json.Decode exposing (Decoder, at, decodeValue)
import Json.Encode
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


type alias Entry =
    { id : Int
    , date : Date
    , content : String
    }


init : ( Model, Cmd Msg )
init =
    ( { entries =
            [ { id = 0
              , date = Date.fromTime -2542792568000
              , content = "Harris said he didn’t think George ought to do anything that would have a tendency to make him sleepier than he always was, as it might be dangerous.  He said he didn’t very well understand how George was going to sleep any more than he did now, seeing that there were only twenty-four hours in each day, summer and winter alike; but thought that if he did sleep any more, he might just as well be dead, and so save his board and lodging."
              }
            , { id = 1
              , date = Date.fromTime -2542691568000
              , content = "We arranged to start on the following Saturday from Kingston.  Harris and I would go down in the morning, and take the boat up to Chertsey, and George, who would not be able to get away from the City till the afternoon (George goes to sleep at a bank from ten to four each day, except Saturdays, when they wake him up and put him outside at two), would meet us there."
              }
            , { id = 2
              , date = Date.fromTime -2542590568000
              , content = "Rainwater is the chief article of diet at supper.  The bread is two-thirds rainwater, the beefsteak-pie is exceedingly rich in it, and the jam, and the butter, and the salt, and the coffee have all combined with it to make soup."
              }
            , { id = 3
              , date = Date.fromTime -2542489568000
              , content = "We made a list of the things to be taken, and a pretty lengthy one it was, before we parted that evening.  The next day, which was Friday, we got them all together, and met in the evening to pack.  We got a big Gladstone for the clothes, and a couple of hampers for the victuals and the cooking utensils.  We moved the table up against the window, piled everything in a heap in the middle of the floor, and sat round and looked at it."
              }
            ]
      , editingIds = []
      , now = Date.fromTime 0
      }
    , Cmd.none
    )



---- UPDATE ----


type alias JsMsgBody =
    { tag : String, payload : Json.Decode.Value }


port sendJsMsg : JsMsgBody -> Cmd msg


entryDecoder : Decoder Entry
entryDecoder =
    Json.Decode.map3 Entry
        (Json.Decode.at [ "id" ] Json.Decode.int)
        (Json.Decode.at [ "date" ] Json.Decode.float |> Json.Decode.map Date.fromTime)
        (Json.Decode.at [ "content" ] Json.Decode.string)


encodeEntry : Entry -> Json.Encode.Value
encodeEntry entry =
    Json.Encode.object
        [ ( "id", Json.Encode.int entry.id )
        , ( "date", Json.Encode.float (Date.toTime entry.date) )
        , ( "content", Json.Encode.string entry.content )
        ]


decodeJsMsg : JsMsgBody -> Msg
decodeJsMsg body =
    let
        decode decoder =
            decodeValue decoder body.payload
    in
    case body.tag of
        "EntriesChanged" ->
            case decode (Json.Decode.list entryDecoder) of
                Ok entries ->
                    EntriesChanged entries

                Err e ->
                    LogErr e

        _ ->
            LogErr ("unrecognized jsMsg " ++ toString body)


port jsMsgs : (JsMsgBody -> msg) -> Sub msg


type Msg
    = NoOp
    | JsMsg JsMsgBody
    | EntriesChanged (List Entry)
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

        JsMsg body ->
            model ! [ sendJsMsg body ]

        EntriesChanged entries ->
            { model | entries = entries }
                ! []

        LogErr err ->
            model ! [ sendJsMsg { tag = "LogError", payload = Json.Encode.string err } ]

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
                ! [ sendJsMsg
                        { tag = "CreateEntry", payload = Json.Encode.null }
                  ]

        UpdateEntry entry ->
            model
                ! [ sendJsMsg
                        { tag = "UpdateEntry", payload = encodeEntry entry }
                  ]

        DeleteEntry id ->
            model
                ! [ sendJsMsg
                        { tag = "DeleteEntry", payload = Json.Encode.int id }
                  ]



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
        [ style Root
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
                    , jsMsgs decodeJsMsg
                    ]
        }
