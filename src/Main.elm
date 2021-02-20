module Main exposing (..)

import Browser
import Html exposing (Html, button, div, fieldset, form, h3, h4, input, legend, text)
import Html.Attributes exposing (class, hidden, id, placeholder, type_, value)
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


afficheDistance : String -> Maybe Float -> String
afficheDistance unite distance =
    case distance of
        Nothing ->
            ""

        Just valeur ->
            String.fromFloat valeur ++ unite


type Etape
    = Debut
    | Geometrie


type alias Model =
    { hauteurPoteaux : MFloat
    , portee : MFloat
    , entraxePortiques : MFloat
    , etape : Etape
    }


type Msg
    = ModifierHauteurPoteaux String
    | ModifierPortee String
    | ModifierEntraxePortiques String
    | SoumettreGeometrie


init : Model
init =
    { hauteurPoteaux = Nothing
    , portee = Nothing
    , entraxePortiques = Nothing
    , etape = Debut
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ModifierHauteurPoteaux valeur ->
            { model | hauteurPoteaux = String.toFloat valeur }

        ModifierPortee valeur ->
            { model | portee = String.toFloat valeur }

        ModifierEntraxePortiques valeur ->
            { model | entraxePortiques = String.toFloat valeur }

        SoumettreGeometrie ->
            { model | etape = Geometrie }


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ viewFormGeometrie model
        , viewResume model
        ]


viewFormGeometrie : Model -> Html Msg
viewFormGeometrie model =
    div []
        [ h3 [] [ text "Geometrie" ]
        , div []
            [ input
                [ type_ "number"
                , id "hauteur-poteau"
                , placeholder "Hauteur du poteau (m)"
                , value (afficheFloat model.hauteurPoteaux)
                , onInput ModifierHauteurPoteaux
                ]
                []
            ]
        , div []
            [ input
                [ type_ "number"
                , id "portee"
                , placeholder "Portée (m)"
                , value (afficheFloat model.portee)
                , onInput ModifierPortee
                ]
                []
            ]
        , div []
            [ input
                [ type_ "number"
                , id "entraxe-portiques"
                , placeholder "Entraxe portiques (m)"
                , value (afficheFloat model.entraxePortiques)
                , onInput ModifierEntraxePortiques
                ]
                []
            ]
        , div []
            [ button [ onClick SoumettreGeometrie ] [ text "Valider" ]
            ]
        ]


viewResume : Model -> Html Msg
viewResume model =
    fieldset []
        [ legend [] [ text "Résumé" ]
        , div [ hidden (model.etape /= Geometrie) ]
            [ h4 [] [ text "Géométrie" ]
            , div []
                [ text "Hauteur du poteau : "
                , text (afficheDistance "m" model.hauteurPoteaux)
                ]
            , div []
                [ text "Portée : "
                , text (afficheDistance "m" model.portee)
                ]
            , div []
                [ text "Entraxe portiques : "
                , text (afficheDistance "m" model.entraxePortiques)
                ]
            ]
        ]
