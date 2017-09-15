module Main where

import Protolude hiding (option)

import Data.Maybe (fromMaybe)

import Nanocoin (initNode)

import Options.Applicative
import Logger

data Config = Config
  { rpcPort      :: Int
  , keysPath     :: Maybe FilePath
  , logFilepath  :: Maybe FilePath
  }

defaultConfig :: Config
defaultConfig = Config 3000 Nothing Nothing

main :: IO ()
main = do
    Config rpc mKeys mLogFile <- execParser (info parser mempty)
    logger <- mkLogger mLogFile
    initNode rpc mKeys logger
  where
    portParser :: Parser (Maybe Int)
    portParser = optional $
      option auto $ long "rpc-port"
                 <> short 'p'
                 <> metavar "RPC_PORT"

    keysParser :: Parser (Maybe FilePath)
    keysParser = optional $
      strOption $ long "keys"
               <> short 'k'
               <> metavar "KEYS_DIR"

    logFileParser :: Parser (Maybe FilePath)
    logFileParser = optional $
      strOption $ long "logfile"
              <> short 'f'
              <> metavar "LOG_FILE"

    parser = Config
      <$> (fromMaybe (rpcPort defaultConfig) <$> portParser)
      <*> keysParser
      <*> logFileParser
