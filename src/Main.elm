module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
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
            -}
            ( model, Cmd.none )

        -- http request が成功したとき
        GotPage (Ok repo) ->
            {- 上の UrlChangedで渡した命令が成功したときどうするか書く -}
            ( model, Cmd.none )

        GotPage (Err repo) ->
            ( model, Cmd.none )



{- subscriptions は runtime で発生したイベントを拾うものなので、 使わない予定
   ネットワーク呼び出しは クリックイベント-> Cnd 作成 -> Msg 受け取り で処理されるので subscriptions ではない
-}


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "gov.uk contents"

    -- you need surrounding bracket
    , body = [ div [] [] ]
    }



-- TODO: ここでは index の api を呼んで Cmd を返す必要があります多分


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )
