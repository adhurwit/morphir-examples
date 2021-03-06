module Morphir.Sample.Apps.Order.ACL exposing (..)


import Dict exposing (Dict)
import Morphir.SDK.App exposing (sendCommand)
import Morphir.Sample.Apps.Shared.Product as Product
import Morphir.Sample.Apps.Order.Order as Order
import Morphir.Sample.Apps.BooksAndRecords.App as BookingApp
import Morphir.Sample.Apps.Upstream.Product.App as ProductApp
import Morphir.Sample.Apps.Order.App as App
import Morphir.Sample.Apps.Shared.Price exposing (..)
import Morphir.Sample.Apps.Shared.Quantity exposing (..)



map : BookingApp.App -> BookingApp.LocalState -> ProductApp.LocalState -> App.RemoteState
map bookingApp bookingState marketState =
    { bookBuy = bookBuy bookingApp
    , bookSell = bookSell bookingApp
    , getDeal = getDeal bookingState
    , getMarketPrice = getMarketPrice marketState
    , getStartOfDayPosition = getStartOfDayPosition marketState
    }


bookBuy : BookingApp.App -> Order.ID -> Product.ID -> Price -> Quantity -> Cmd App.Event
bookBuy bookingApp orderId productId price quantity =
    bookingApp 
        |> sendCommand 
            (\api -> api.openDeal orderId productId price quantity) 
            (\fault -> [])


bookSell : BookingApp.App -> Order.ID -> Price -> Cmd App.Event
bookSell bookingApp orderId price =
    bookingApp 
        |> sendCommand 
            (\api -> api.closeDeal orderId) 
            (\fault -> [])


getDeal : BookingApp.LocalState -> Order.ID -> Maybe Order.Deal
getDeal bookingState dealId =
    bookingState
        |> Dict.get dealId 
        |> Maybe.map (\dealAppDeal -> 
            Order.Deal dealAppDeal.id dealAppDeal.product dealAppDeal.price dealAppDeal.quantity
        )


getMarketPrice : ProductApp.LocalState -> Product.ID -> Maybe Price
getMarketPrice productState productId =
    productState |> Dict.get productId |> Maybe.map .price


getStartOfDayPosition : ProductApp.LocalState -> Product.ID -> Maybe Quantity
getStartOfDayPosition productState productId =
    productState |> Dict.get productId |> Maybe.map .startOfDayPosition

