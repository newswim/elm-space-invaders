module Game exposing (..)

import Html exposing (Html, text)
import Keyboard exposing (KeyCode)
import AnimationFrame
import Time exposing (Time)
import Key exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { position : Float
    , velocity : Float
    , shotsFired : Int
    }


model : Model
model =
    { position = 0
    , velocity = 0
    , shotsFired = 0
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html msg
view model =
    text (toString model)



-- UPDATE


type Msg
    = TimeUpdate Time
    | KeyDown KeyCode
    | KeyUp KeyCode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeUpdate dt ->
            ( applyPhysics dt model, Cmd.none )

        KeyDown keyCode ->
            ( keyDown keyCode model, Cmd.none )

        KeyUp keyCode ->
            ( keyUp keyCode model, Cmd.none )


keyDown : KeyCode -> Model -> Model
keyDown keyCode model =
    case Key.fromCode keyCode of
        Space ->
            incrementShotsFired model

        ArrowLeft ->
            updateVelocity -1.0 model

        ArrowRight ->
            updateVelocity 1.0 model

        _ ->
            model


keyUp : KeyCode -> Model -> Model
keyUp keyCode model =
    case Key.fromCode keyCode of
        ArrowLeft ->
            updateVelocity 0 model

        ArrowRight ->
            updateVelocity 0 model

        _ ->
            model



-- WORKER/HELPER FUNCTIONS


applyPhysics : Time -> Model -> Model
applyPhysics dt model =
    { model | position = model.position + (model.velocity * dt) }


updateVelocity : Float -> Model -> Model
updateVelocity newVelocity model =
    { model | velocity = newVelocity }


incrementShotsFired : Model -> Model
incrementShotsFired model =
    { model | shotsFired = model.shotsFired + 1 }



-- DATA SUBS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs TimeUpdate
        , Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        ]
