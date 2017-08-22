module Entry exposing (..)

import Date exposing (Date)
import Json.Decode exposing (Decoder)
import Json.Encode


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


type alias Entry =
    { id : Int
    , date : Date
    , content : String
    }
