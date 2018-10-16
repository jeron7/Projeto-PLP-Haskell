{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_JumpMaster (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/jeron7/.cabal/bin"
libdir     = "/home/jeron7/.cabal/lib/x86_64-linux-ghc-7.10.3/JumpMaster-0.1.0.0"
dynlibdir  = "/home/jeron7/.cabal/lib/x86_64-linux-ghc-7.10.3"
datadir    = "/home/jeron7/.cabal/share/x86_64-linux-ghc-7.10.3/JumpMaster-0.1.0.0"
libexecdir = "/home/jeron7/.cabal/libexec"
sysconfdir = "/home/jeron7/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "JumpMaster_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "JumpMaster_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "JumpMaster_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "JumpMaster_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "JumpMaster_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "JumpMaster_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
