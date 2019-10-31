{- The trivial resource -}
module Relation.Ternary.Separation.Construct.Unit where

open import Data.Unit
open import Data.Product

open import Relation.Unary
open import Relation.Binary hiding (_⇒_)
open import Relation.Binary.PropositionalEquality as P
open import Relation.Ternary.Separation

open RawSep
instance unit-raw-sep : RawSep ⊤
_⊎_≣_ unit-raw-sep = λ _ _ _ → ⊤

instance unit-has-sep : IsSep unit-raw-sep
unit-has-sep = record
  { ⊎-comm  = λ _   → tt
  ; ⊎-assoc = λ _ _ → tt , tt , tt
  }

instance unit-has-unit⁺ : HasUnit⁺ _ _
unit-has-unit⁺ = record
  { ⊎-idˡ = tt }

instance unit-has-unit⁻ : HasUnit⁻ _ _
unit-has-unit⁻ = record
  { ⊎-id⁻ˡ = λ where tt → refl }

instance unit-is-unital : IsUnitalSep _ _
unit-is-unital = record {}
