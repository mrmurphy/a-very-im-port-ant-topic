port module OutsideInfo exposing (..)

import Entry exposing (Entry, encodeEntry, entryDecoder)
import Json.Decode exposing (decodeValue)
import Json.Encode


sendInfoOutside : InfoForOutside -> Cmd msg
sendInfoOutside info =
    case info of
        CreateEntry ->
            infoForOutside { tag = "CreateEntry", data = Json.Encode.null }

        ModifyEntry entry ->
            infoForOutside { tag = "ModifyEntry", data = encodeEntry entry }

        DeleteEntry id ->
            infoForOutside { tag = "DeleteEntry", data = Json.Encode.int id }

        LogError err ->
            infoForOutside { tag = "LogError", data = Json.Encode.string err }


getInfoFromOutside : (InfoForElm -> msg) -> (String -> msg) -> Sub msg
getInfoFromOutside tagger onError =
    infoForElm
        (\outsideInfo ->
            case outsideInfo.tag of
                "EntriesChanged" ->
                    case decodeValue (Json.Decode.list entryDecoder) outsideInfo.data of
                        Ok entries ->
                            tagger <| EntriesChanged entries

                        Err e ->
                            onError e

                _ ->
                    onError <| "Unexpected info from outside: " ++ toString outsideInfo
        )


type InfoForOutside
    = CreateEntry
    | ModifyEntry Entry
    | DeleteEntry Int
    | LogError String


type InfoForElm
    = EntriesChanged (List Entry)


type alias GenericOutsideData =
    { tag : String, data : Json.Encode.Value }


port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElm : (GenericOutsideData -> msg) -> Sub msg
