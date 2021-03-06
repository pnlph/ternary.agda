{-# OPTIONS --safe #-}
open import Relation.Ternary.Separation

module Relation.Ternary.Separation.Decoration
  {ℓₐ} {A : Set ℓₐ}
  {{raw : RawSep A}}
  where

open import Level
open import Function
open import Algebra.Core

open import Data.Product

open import Relation.Unary
open import Relation.Binary.PropositionalEquality

private
  variable
    a₁ a₂ a : A

-- Separation decorations
module _ where
  record Decoration {d} (D : Pred A d) : Set (ℓₐ ⊔ d) where
    field
      split : a₁ ⊎ a₂ ≣ a → D a → D a₁ × D a₂

    decorˡ  : a₁ ⊎ a₂ ≣ a → D a → D a₁
    decorˡ σ = proj₁ ∘ split σ

    decorʳ  : a₁ ⊎ a₂ ≣ a → D a → D a₂
    decorʳ σ = proj₂ ∘ split σ

  open Decoration {{...}} public

module _ {u : A} {{_ : HasUnit⁺ raw u}} where
  record UnitDecoration {d} (D : Pred A d) : Set (ℓₐ ⊔ d) where
    field
      decorate-ε : D ε

  open UnitDecoration {{...}} public

{- decorated carriers give rise to a separation algebra -}
module _ {d} {D : Pred A d} {{_ : Decoration D}} (_⊕_ : ∀ {a} → D a → D a → D a)where
  Decorated = ∃ D

  ann-⊎ : Decorated → Decorated → Decorated → Set (ℓₐ ⊔ d)
  ann-⊎ (a₁ , _) (a₂ , _) (a , _) = Lift d (a₁ ⊎ a₂ ≣ a)

  instance
    ann-raw : RawSep Decorated
    RawSep._⊎_≣_ ann-raw = ann-⊎

    ann-is-sep : {{_ : IsSep raw}} → IsSep ann-raw
    IsSep.⊎-comm ann-is-sep (lift σ) = lift (⊎-comm σ)
    IsSep.⊎-assoc ann-is-sep {abc = abc} (lift σ₁) (lift σ₂) =
      let a , σ₃ , σ₄ = ⊎-assoc σ₁ σ₂
      in (a , decorˡ (⊎-comm σ₃) (proj₂ abc)) , lift σ₃ , lift σ₄

  
    ann-has-unit⁺ : ∀ {u} {{_ : HasUnit⁺ raw u}} {{_ : UnitDecoration D}}
                    → HasUnit⁺ ann-raw (ε , decorate-ε)
    HasUnit⁺.⊎-idˡ ann-has-unit⁺ = lift ⊎-idˡ
