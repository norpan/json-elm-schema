module Helpers exposing (..)

import Json.Decode as Decode exposing (..)
import Expect


expectAt : List String -> ( Decoder a, a ) -> String -> Expect.Expectation
expectAt path ( decoder, expected ) actual =
    let
        result : Result String a
        result =
            decodeString (at path decoder) actual
    in
        case result of
            Ok decoded ->
                Expect.equal expected decoded

            Err error ->
                Expect.fail ("Couldn't decode schema: " ++ error)


lengthAt : List String -> Int -> String -> Expect.Expectation
lengthAt path expectedLength jsonString =
    let
        result : Result String (List Value)
        result =
            decodeString (at path (list value)) jsonString
    in
        case result of
            Ok decoded ->
                Expect.equal expectedLength (List.length decoded)

            Err error ->
                Expect.fail ("Couldn't decode schema: " ++ error)
