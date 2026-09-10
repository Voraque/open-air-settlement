# Better Recipe Book terminal crash fix

Two supplied crash reports show NullPointerException in instantcraft.RecipeButtonMixin.getOrderedRecipes when lastClicked is null in Toms Storage terminal. Config alone does not gate this injected method. OAS patch removes the five instantcraft mixin registrations and disables its button/config; other classes and features are preserved. Original MIT license is retained. Original client jar and config backed up privately. No server changes required. Archive and registration checks pass; rendered terminal acceptance test still needed.
