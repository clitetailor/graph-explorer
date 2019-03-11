module Lib where

import           Web.Spock                      ( SpockM
                                                , runSpock
                                                , spock
                                                , root
                                                )
import qualified Web.Spock                     as Spock
import           Web.Spock.Config               ( defaultSpockCfg
                                                , PoolOrConn(PCNoDatabase)
                                                )

import           Control.Monad.IO.Class         ( liftIO )

import           Data.IORef                     ( IORef
                                                , newIORef
                                                )
import           Data.Monoid                    ( (<>) )
import           Data.Text                      ( unpack
                                                , pack
                                                )
import           Data.Text.Encoding             ( decodeUtf8 )

data MySession = EmptySession
data MyAppState = DummyAppState (IORef Int)

serverMain :: IO ()
serverMain = do
  ref      <- newIORef 0
  spockCfg <- defaultSpockCfg EmptySession PCNoDatabase (DummyAppState ref)
  runSpock 8080 (spock spockCfg app)

app :: SpockM () MySession MyAppState ()
app = Spock.post root $ do
  rawText <- Spock.body
  Spock.text (pack "Hello " <> decodeUtf8 rawText)
