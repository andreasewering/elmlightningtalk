module ElmTest exposing (unitTest)

import Expect
import Fuzz
import Test exposing (Test, describe, fuzz, test)


complicatedAlgorithm : Int -> Int
complicatedAlgorithm =
    (+) 1


complicatedAlgorithm2 : Int -> Int
complicatedAlgorithm2 input =
    if input == 5 then
        0

    else
        input + 1


unitTest : Test
unitTest =
    describe "complicated algorithm"
        [ test "unit test a single case" <|
            \_ ->
                complicatedAlgorithm 1
                    |> Expect.equal 2
        , fuzz Fuzz.int "fuzz test a behaviour" <|
            \number ->
                complicatedAlgorithm number
                    |> Expect.equal (number + 1)
        ]
