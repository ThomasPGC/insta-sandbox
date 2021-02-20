module Main exposing (..)

import Browser
import Html exposing (Html, button, div, fieldset, h3, h4, input, legend, text)
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


afficheAvecUnite : String -> Maybe Float -> String
afficheAvecUnite unite distance =
    case distance of
        Nothing ->
            ""

        Just valeur ->
            String.fromFloat valeur ++ unite


type Etape
    = Geometrie
    | Charges
    | Fin


type alias Model =
    { hauteurPoteaux : MFloat
    , portee : MFloat
    , entraxePortiques : MFloat
    , poidsCouverture : MFloat
    , poidsDivers : MFloat
    , etape : Etape
    }


type Msg
    = ModifierHauteurPoteaux String
    | ModifierPortee String
    | ModifierEntraxePortiques String
    | ModifierPoidsCouverture String
    | ModifierPoidsDivers String
    | RevenirAuDebut
    | SoumettreGeometrie
    | SoumettreCharges


init : Model
init =
    { hauteurPoteaux = Nothing
    , portee = Nothing
    , entraxePortiques = Nothing
    , poidsCouverture = Nothing
    , poidsDivers = Nothing
    , etape = Geometrie
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

        ModifierPoidsCouverture valeur ->
            { model | poidsCouverture = String.toFloat valeur }

        ModifierPoidsDivers valeur ->
            { model | poidsDivers = String.toFloat valeur }

        RevenirAuDebut ->
            { model | etape = Geometrie }

        SoumettreGeometrie ->
            { model | etape = Charges }

        SoumettreCharges ->
            { model | etape = Fin }


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ viewFormGeometrie model (model.etape == Geometrie)
        , viewFormCharges model (model.etape == Charges)
        , div [ hidden (model.etape /= Fin) ]
            [ text "Fin"
            , button [ onClick RevenirAuDebut ] [ text "Revenir au début" ]
            , button [ onClick SoumettreGeometrie ] [ text "Précédent" ]
            ]
        , viewResume model
        ]


viewFormGeometrie : Model -> Show -> Html Msg
viewFormGeometrie model show =
    div [ hidden (not show) ]
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
            [ button [ onClick SoumettreGeometrie ] [ text "Suivant" ]
            ]
        ]


type alias Show =
    Bool


viewFormCharges : Model -> Show -> Html Msg
viewFormCharges model show =
    div [ hidden (not show) ]
        [ h3 [] [ text "Charges" ]
        , div []
            [ input
                [ type_ "number"
                , id "poids-couverture"
                , placeholder "Poids propre couverture (kg/m2)"
                , value (afficheFloat model.poidsCouverture)
                , onInput ModifierPoidsCouverture
                ]
                []
            ]
        , div []
            [ input
                [ type_ "number"
                , id "poids-divers"
                , placeholder "Poids propre divers sous couverture (kg/m2)"
                , value (afficheFloat model.poidsDivers)
                , onInput ModifierPoidsDivers
                ]
                []
            ]
        , div []
            [ button [ onClick RevenirAuDebut ] [ text "Précédent" ]
            , button [ onClick SoumettreCharges ] [ text "Suivant" ]
            ]
        ]


viewResume : Model -> Html Msg
viewResume model =
    fieldset []
        [ legend [] [ text "Résumé" ]
        , div [ hidden (model.etape == Geometrie) ]
            [ h4 [] [ text "Géométrie" ]
            , div []
                [ text "Hauteur du poteau : "
                , text (afficheAvecUnite "m" model.hauteurPoteaux)
                ]
            , div []
                [ text "Portée : "
                , text (afficheAvecUnite "m" model.portee)
                ]
            , div []
                [ text "Entraxe portiques : "
                , text (afficheAvecUnite "m" model.entraxePortiques)
                ]
            ]
        , div [ hidden (List.member model.etape [ Geometrie, Charges ]) ]
            [ h4 [] [ text "Charges" ]
            , div []
                [ text "Poids propre couverture"
                , text (afficheAvecUnite "kg/m2" model.poidsCouverture)
                ]
            , div []
                [ text "Poids propre divers sous toiture : "
                , text (afficheAvecUnite "kg/m2" model.poidsDivers)
                ]
            ]
        ]
