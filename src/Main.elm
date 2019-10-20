module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as D exposing (Decoder)
import Url
import Url.Builder


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update

        {- subscriptions は runtime で発生したイベントを拾うものなので、 使わない予定
           ネットワーク呼び出しは クリックイベント-> Cnd 作成 -> Msg 受け取り で処理されるので subscriptions ではない
        -}
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , parentContentName : Maybe String
    , contentName : String
    , taxons : List Taxon
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotPage (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- 画面遷移のリクエストがきたとき
        LinkClicked urlRequest ->
            case urlRequest of
                -- 内部リンク
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                -- 外部リンク
                Browser.External href ->
                    ( model, Nav.load href )

        -- url が変更されたとき
        UrlChanged urlRequest ->
            {- TODO:
               大まかな処理としては、 url から api のパスを作って呼び出し命令 (Cmd) を出して終わり
               なんだけどリンククリックと大差ないので後回し
            -}
            ( model, Cmd.none )

        -- http request が成功したとき
        GotPage (Ok page) ->
            {- 上の UrlChangedで渡した命令が成功したときどうするか書く -}
            case decodePage page of
                Ok ts ->
                    ( { model | taxons = ts }
                    , Cmd.none
                    )

                Err e ->
                    ( Debug.log (D.errorToString e) model, Cmd.none )

        GotPage (Err page) ->
            ( Debug.log (Debug.toString page) model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "gov.uk contents"

    -- you need surrounding bracket
    , body =
        [ h1 []
            [ text model.contentName ]
        , h2 []
            [ text (parentContent model.parentContentName) ]
        , div [] (taxonList model.taxons)
        ]
    }


parentContent : Maybe String -> String
parentContent s =
    "Parent Content: "
        ++ (case s of
                Just n ->
                    n

                Nothing ->
                    "None"
           )


taxonList : List Taxon -> List (Html Msg)
taxonList ts =
    List.map
        taxonLink
        ts


taxonLink : Taxon -> Html Msg
taxonLink t =
    li [] [ a [ href t.basePath ] [ text t.basePath ] ]



-- TODO: ここでは index の api を呼んで Cmd を返す必要があります多分


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url Nothing "Index" []
    , Http.get
        { url = apiUrl "/api/content"
        , expect = Http.expectString GotPage
        }
    )



-- page の情報を表す型


type alias Taxon =
    { apiPath : String
    , basePath : String
    , title : String
    }


taxonDecoder : Decoder Taxon
taxonDecoder =
    D.map3 Taxon
        (D.field "api_path" D.string)
        (D.field "base_path" D.string)
        (D.field "title" D.string)


decodePage : String -> Result D.Error (List Taxon)
decodePage page =
    -- links 以外はどうでもいいので型を作ってません
    D.decodeString (D.at [ "links", "level_one_taxons" ] (D.list taxonDecoder)) page



-- api url を作るためのヘルパー


apiUrl : String -> String
apiUrl path =
    Url.Builder.crossOrigin "http://localhost:8080"
        [ "gov" ]
        [ Url.Builder.string "p" path ]
