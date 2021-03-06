module Tests exposing (spec)

import Expect
import Helpers exposing (expectAt, lengthAt)
import Json.Decode as Decode
import JsonSchema exposing (..)
import JsonSchema.Encoder exposing (encode)
import Test exposing (..)


spec : Test
spec =
    describe "JsonSchema"
        [ objectSchemaSpec
        , arraySchemaSpec
        , stringSchemaSpec
        , stringEnumSchemaSpec
        , integerSchemaSpec
        , integerEnumSchemaSpec
        , numberSchemaSpec
        , numberEnumSchemaSpec
        , booleanSchemaSpec
        , nullSchemaSpec
        , schemaCombinersSpec
        ]


objectSchemaSpec : Test
objectSchemaSpec =
    let
        objectSchema : Schema
        objectSchema =
            object
                [ title "object schema title"
                , description "object schema description"
                , properties
                    [ optional "firstName" <| string []
                    , required "lastName" <| string []
                    ]
                ]
    in
        describe "object schema"
            [ test "title property is set" <|
                \() ->
                    encode objectSchema
                        |> expectAt
                            [ "title" ]
                            ( Decode.string, "object schema title" )
            , test "description property is set" <|
                \() ->
                    encode objectSchema
                        |> expectAt
                            [ "description" ]
                            ( Decode.string, "object schema description" )
            , test "has the right type" <|
                \() ->
                    encode objectSchema
                        |> expectAt
                            [ "type" ]
                            ( Decode.string, "object" )
            , test "adds the right properties to 'required'" <|
                \() ->
                    encode objectSchema
                        |> expectAt
                            [ "required", "0" ]
                            ( Decode.string, "lastName" )
            , test "array 'required' has correct length" <|
                \() ->
                    encode objectSchema
                        |> lengthAt [ "required" ] 1
            , test "first object property exists as nested schema" <|
                \() ->
                    encode objectSchema
                        |> expectAt
                            [ "properties", "firstName", "type" ]
                            ( Decode.string, "string" )
            , test "second object property exists as nested schema" <|
                \() ->
                    encode objectSchema
                        |> expectAt
                            [ "properties", "lastName", "type" ]
                            ( Decode.string, "string" )
            ]


arraySchemaSpec : Test
arraySchemaSpec =
    let
        arraySchema : Schema
        arraySchema =
            array
                [ title "array schema title"
                , description "array schema description"
                , items <| string []
                , minItems 3
                , maxItems 6
                ]
    in
        describe "array schema"
            [ test "title property is set" <|
                \() ->
                    encode arraySchema
                        |> expectAt
                            [ "title" ]
                            ( Decode.string, "array schema title" )
            , test "description property is set" <|
                \() ->
                    encode arraySchema
                        |> expectAt
                            [ "description" ]
                            ( Decode.string, "array schema description" )
            , test "has the right type" <|
                \() ->
                    encode arraySchema
                        |> expectAt
                            [ "type" ]
                            ( Decode.string, "array" )
            , test "items property contains nested schema" <|
                \() ->
                    encode arraySchema
                        |> expectAt
                            [ "items", "type" ]
                            ( Decode.string, "string" )
            , test "minItems property contains nested schema" <|
                \() ->
                    encode arraySchema
                        |> expectAt
                            [ "minItems" ]
                            ( Decode.int, 3 )
            , test "maxItems property contains nested schema" <|
                \() ->
                    encode arraySchema
                        |> expectAt
                            [ "maxItems" ]
                            ( Decode.int, 6 )
            ]


stringSchemaSpec : Test
stringSchemaSpec =
    let
        stringSchema : Schema
        stringSchema =
            string
                [ title "string schema title"
                , description "string schema description"
                , minLength 2
                , maxLength 8
                , pattern "^foo$"
                , format dateTime
                ]
    in
        describe "string schema"
            [ test "title property is set" <|
                \() ->
                    encode stringSchema
                        |> expectAt
                            [ "title" ]
                            ( Decode.string, "string schema title" )
            , test "description property is set" <|
                \() ->
                    encode stringSchema
                        |> expectAt
                            [ "description" ]
                            ( Decode.string, "string schema description" )
            , test "has the right type" <|
                \() ->
                    encode stringSchema
                        |> expectAt
                            [ "type" ]
                            ( Decode.string, "string" )
            , test "minLength property is set" <|
                \() ->
                    encode stringSchema
                        |> expectAt
                            [ "minLength" ]
                            ( Decode.int, 2 )
            , test "maxLength property is set" <|
                \() ->
                    encode stringSchema
                        |> expectAt
                            [ "maxLength" ]
                            ( Decode.int, 8 )
            , test "pattern property is set" <|
                \() ->
                    encode stringSchema
                        |> expectAt
                            [ "pattern" ]
                            ( Decode.string, "^foo$" )
            , test "format property is set" <|
                \() ->
                    encode stringSchema
                        |> expectAt
                            [ "format" ]
                            ( Decode.string, "date-time" )
            ]


stringEnumSchemaSpec : Test
stringEnumSchemaSpec =
    let
        stringEnumSchema : Schema
        stringEnumSchema =
            string
                [ title "string schema title"
                , enum [ "a", "b" ]
                ]
    in
        describe "string enum schema"
            [ test "title property is set" <|
                \() ->
                    encode stringEnumSchema
                        |> expectAt
                            [ "title" ]
                            ( Decode.string, "string schema title" )
            , test "enum property is set" <|
                \() ->
                    encode stringEnumSchema
                        |> expectAt
                            [ "enum" ]
                            ( Decode.list Decode.string, [ "a", "b" ] )
            ]


integerEnumSchemaSpec : Test
integerEnumSchemaSpec =
    let
        integerEnumSchema : Schema
        integerEnumSchema =
            integer
                [ title "integer schema title"
                , enum [ 1, 2 ]
                ]
    in
        describe "integer enum schema"
            [ test "title property is set" <|
                \() ->
                    encode integerEnumSchema
                        |> expectAt
                            [ "title" ]
                            ( Decode.string, "integer schema title" )
            , test "enum property is set" <|
                \() ->
                    encode integerEnumSchema
                        |> expectAt
                            [ "enum" ]
                            ( Decode.list Decode.int, [ 1, 2 ] )
            ]


integerSchemaSpec : Test
integerSchemaSpec =
    let
        integerSchema : Schema
        integerSchema =
            integer
                [ title "integer schema title"
                , description "integer schema description"
                , minimum 2
                , maximum 8
                ]
    in
        describe "integer schema"
            [ test "title property is set" <|
                \() ->
                    encode integerSchema
                        |> expectAt
                            [ "title" ]
                            ( Decode.string, "integer schema title" )
            , test "description property is set" <|
                \() ->
                    encode integerSchema
                        |> expectAt
                            [ "description" ]
                            ( Decode.string, "integer schema description" )
            , test "has the right type" <|
                \() ->
                    encode integerSchema
                        |> expectAt
                            [ "type" ]
                            ( Decode.string, "integer" )
            , test "minimum property is set" <|
                \() ->
                    encode integerSchema
                        |> expectAt
                            [ "minimum" ]
                            ( Decode.int, 2 )
            , test "maximum property is set" <|
                \() ->
                    encode integerSchema
                        |> expectAt
                            [ "maximum" ]
                            ( Decode.int, 8 )
            ]


numberSchemaSpec : Test
numberSchemaSpec =
    let
        numberSchema : Schema
        numberSchema =
            number
                [ title "number schema title"
                , description "number schema description"
                , minimum 2.5
                , maximum 8.3
                ]
    in
        describe "number schema"
            [ test "title property is set" <|
                \() ->
                    encode numberSchema
                        |> expectAt
                            [ "title" ]
                            ( Decode.string, "number schema title" )
            , test "description property is set" <|
                \() ->
                    encode numberSchema
                        |> expectAt
                            [ "description" ]
                            ( Decode.string, "number schema description" )
            , test "has the right type" <|
                \() ->
                    encode numberSchema
                        |> expectAt
                            [ "type" ]
                            ( Decode.string, "number" )
            , test "minimum property is set" <|
                \() ->
                    encode numberSchema
                        |> expectAt
                            [ "minimum" ]
                            ( Decode.float, 2.5 )
            , test "maximum property is set" <|
                \() ->
                    encode numberSchema
                        |> expectAt
                            [ "maximum" ]
                            ( Decode.float, 8.3 )
            ]


numberEnumSchemaSpec : Test
numberEnumSchemaSpec =
    let
        numberEnumSchema : Schema
        numberEnumSchema =
            number
                [ title "number schema title"
                , enum [ 1.2, 3.4 ]
                ]
    in
        describe "number schema"
            [ test "title property is set" <|
                \() ->
                    encode numberEnumSchema
                        |> expectAt
                            [ "title" ]
                            ( Decode.string, "number schema title" )
            , test "description property is set" <|
                \() ->
                    encode numberEnumSchema
                        |> expectAt
                            [ "enum" ]
                            ( Decode.list Decode.float, [ 1.2, 3.4 ] )
            ]


booleanSchemaSpec : Test
booleanSchemaSpec =
    let
        booleanSchema : Schema
        booleanSchema =
            boolean
                [ title "boolean schema title"
                , description "boolean schema description"
                ]
    in
        describe "boolean schema"
            [ test "title property is set" <|
                \() ->
                    encode booleanSchema
                        |> expectAt
                            [ "title" ]
                            ( Decode.string, "boolean schema title" )
            , test "description property is set" <|
                \() ->
                    encode booleanSchema
                        |> expectAt
                            [ "description" ]
                            ( Decode.string, "boolean schema description" )
            , test "has the right type" <|
                \() ->
                    encode booleanSchema
                        |> expectAt
                            [ "type" ]
                            ( Decode.string, "boolean" )
            ]


nullSchemaSpec : Test
nullSchemaSpec =
    let
        nullSchema : Schema
        nullSchema =
            null
                [ title "null schema title"
                , description "null schema description"
                ]
    in
        describe "null schema"
            [ test "title property is set" <|
                \() ->
                    encode nullSchema
                        |> expectAt
                            [ "title" ]
                            ( Decode.string, "null schema title" )
            , test "description property is set" <|
                \() ->
                    encode nullSchema
                        |> expectAt
                            [ "description" ]
                            ( Decode.string, "null schema description" )
            , test "has the right type" <|
                \() ->
                    encode nullSchema
                        |> expectAt
                            [ "type" ]
                            ( Decode.string, "null" )
            ]


schemaCombinersSpec : Test
schemaCombinersSpec =
    let
        integerSchema =
            integer []

        stringSchema =
            string []
    in
        describe "schema combiners"
            [ test "oneOf" <|
                \() ->
                    encode (oneOf [] [ integerSchema, stringSchema ])
                        |> Expect.all
                            [ expectAt
                                [ "oneOf", "0", "type" ]
                                ( Decode.string, "integer" )
                            , expectAt
                                [ "oneOf", "1", "type" ]
                                ( Decode.string, "string" )
                            ]
            , test "allOf" <|
                \() ->
                    encode (allOf [] [ integerSchema, stringSchema ])
                        |> Expect.all
                            [ expectAt
                                [ "allOf", "0", "type" ]
                                ( Decode.string, "integer" )
                            , expectAt
                                [ "allOf", "1", "type" ]
                                ( Decode.string, "string" )
                            ]
            , test "anyOf" <|
                \() ->
                    encode (anyOf [] [ integerSchema, stringSchema ])
                        |> Expect.all
                            [ expectAt
                                [ "anyOf", "0", "type" ]
                                ( Decode.string, "integer" )
                            , expectAt
                                [ "anyOf", "1", "type" ]
                                ( Decode.string, "string" )
                            ]
            ]
