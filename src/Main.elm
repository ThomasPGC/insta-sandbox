module Main exposing (..)

import Browser
import Html exposing (Html, button, div, fieldset, form, input, legend, text)
import Html.Attributes exposing (class, id, placeholder, type_, value)
import Html.Events exposing (onClick)


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
    { hauteurPoteaux : MFloat
    , portee : MFloat
    , entraxePortiques : MFloat
    }


type Msg
    = SoumettreGeometrie Float Float Float


init : Model
init =
    { hauteurPoteaux = Nothing
    , portee = Nothing
    , entraxePortiques = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        SoumettreGeometrie hp p ep ->
            { model | hauteurPoteaux = Just hp, portee = Just p, entraxePortiques = Just ep }


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ div []
            [ input [ type_ "number", id "hauteur-poteau", placeholder "Hauteur du poteau (m)", value (afficheFloat model.hauteurPoteaux) ] []
            , input [ type_ "number", id "portee", placeholder "Portée (m)", value (afficheFloat model.portee) ] []
            , input [ type_ "number", id "entraxe-portiques", placeholder "Entraxe portiques (m)", value (afficheFloat model.entraxePortiques) ] []
            , button [ onClick (SoumettreGeometrie 10 4 5) ] [ text "Valider" ]
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

