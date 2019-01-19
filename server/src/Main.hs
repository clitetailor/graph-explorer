module Main where

import Web.Spock
import Web.Spock.Config

import Control.Monad.Trans
import Data.Aeson hiding (json)
import Data.Monoid ((<>))
import Data.Text (pack)
import Data.IORef
import GHC.Generics

data MySession = EmptySession
data MyAppState = DummyAppState (IORef Int)

main :: IO ()
main = do
    ref <- newIORef 0
    spockCfg <- defaultSpockCfg EmptySession PCNoDatabase (DummyAppState ref)
    runSpock 3000 (spock spockCfg app)

app :: SpockM () MySession MyAppState ()
app = do
    get root $
        text "Hello World!"
    get ("hello" <//> var) $ \name -> do
        (DummyAppState ref) <- getState
        visitorNumber <- liftIO $ atomicModifyIORef' ref $ \i ->
            (i + 1, i + 1)
        text ("Hello " <> name <> ", you are visitor number " <> pack (show visitorNumber))
