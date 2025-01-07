{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend)
import Hakyll
import Debug.Trace

myConfiguration :: Configuration
myConfiguration = defaultConfiguration {
  destinationDirectory = "docs"
}

main :: IO ()
main = hakyllWith myConfiguration $ do
  match "index.html" $ do
    route idRoute
    compile $ do
      recipes <- loadAll "Recepten/*"
      return $ trace (show $ length recipes) 1
      let indexCtx =
            listField "recipes" recipeCtx (return recipes)
            `mappend` defaultContext
      getResourceBody
        >>= applyAsTemplate indexCtx
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

  match "Recepten/*markdown" $ do
    route   $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/recipe.html" recipeCtx
      >>= loadAndApplyTemplate "templates/default.html" recipeCtx

  match "templates/*" $ compile templateBodyCompiler

recipeCtx :: Context String
recipeCtx = defaultContext
