module Main exposing (..)

import Browser
import Html exposing (Html, button, div, fieldset, form, input, legend, text)
import Html.Attributes exposing (class, id, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias MFloat =
    Maybe Float


afficheFloat : Maybe Float -> String
afficheFloat valeur =
    case valeur of
        Nothing ->
            ""

        Just f ->
            String.fromFloat f


type alias Model =
    { hauteurPoteaux : Maybe Float
    , portee : Maybe Float
    , entraxePortiques : Maybe Float
    , volume : Maybe Float
    }


type Msg
    = SoumettreGeometrie
    | ChangeHaut String
    | ChangePort String
    | ChangeEntr String


init : Model
init =
    { hauteurPoteaux = Nothing
    , portee = Nothing
    , entraxePortiques = Nothing
    , volume = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        SoumettreGeometrie ->
            { model | volume = Nothing }

        ChangeHaut newvalue ->
            { model | hauteurPoteaux = String.toFloat newvalue }

        ChangePort newvalue ->
            { model | portee = String.toFloat newvalue }

        ChangeEntr newvalue ->
            { model | entraxePortiques = String.toFloat newvalue }




view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ div []
            [ input [ id "hauteur-poteau", placeholder "Hauteur du poteau (m)", value (afficheFloat model.hauteurPoteaux), onInput ChangeHaut ] []
            , input [ id "portee", placeholder "Portée (m)", value (afficheFloat model.portee), onInput ChangePort ] []
            , input [ id "entraxe-portiques", placeholder "Entraxe portiques (m)", value (afficheFloat model.entraxePortiques), onInput ChangeEntr ] []
            , button [ onClick (SoumettreGeometrie ) ] [ text "Valider" ]
            ]
        , fieldset []
            [ legend [] [ text "Résumé" ]
            , div []
                [ text "Hauteur du poteau :"
                , text (afficheFloat model.hauteurPoteaux)
                ]
            , div []
                [ text "Portée :"
                , text (afficheFloat model.portee)
                ]
            , div []
                [ text "Entraxe portiques :"
                , text (afficheFloat model.entraxePortiques)
                ]
            ]
        ]



-- juste un commentaire
