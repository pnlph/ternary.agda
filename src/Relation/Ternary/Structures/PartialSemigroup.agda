{-# OPTIONS --safe #-}
module Relation.Ternary.Structures.PartialSemigroup {a} {A : Set a} where

open import Level
open import Relation.Unary
open import Relation.Binary.Structures
open import Relation.Ternary.Core using (Rel₃; Respect; coe; RightAssoc; LeftAssoc)

open import Function using (_∘_)
open import Data.Product

record IsPartialSemigroup {e} (_≈_ : A → A → Set e) (rel : Rel₃ A) : Set (a ⊔ e) where
  open Rel₃ rel

  field
    overlap {{ ≈-equivalence }} : IsEquivalence _≈_

    -- the relation respects the equivalence in all positions
    overlap {{∙-respects-≈}}  : ∀ {Φ₁ Φ₂} → Respect _≈_ (Φ₁ ∙ Φ₂)
    overlap {{∙-respects-≈ˡ}} : ∀ {Φ₂ Φ}  → Respect _≈_ (_∙ Φ₂ ≣ Φ)
    overlap {{∙-respects-≈ʳ}} : ∀ {Φ₁ Φ}  → Respect _≈_ (Φ₁ ∙_≣ Φ)

    ∙-assocᵣ : RightAssoc rel
    ∙-assocₗ : LeftAssoc rel

  -- the "product" and arrow respect the equivalence
  module _ where

    instance ⊙-respect-≈ : ∀ {p q} {P : Pred A p} {Q : Pred A q} → Respect _≈_ (P ⊙ Q)
    Respect.coe ⊙-respect-≈ eq (px ∙⟨ σ ⟩ qx) = px ∙⟨ coe eq σ ⟩ qx

    instance ─⊙-respect-≈ : ∀ {p q} {P : Pred A p} {Q : Pred A q} → Respect _≈_ (P ─⊙ Q)
    Respect.coe ─⊙-respect-≈ eq f ⟨ σ ⟩ px = f ⟨ coe (IsEquivalence.sym ≈-equivalence eq) σ ⟩ px

  -- pairs rotate and reassociate
  module _ {p q r} {P : Pred A p} {Q : Pred A q} {R : Pred A r} where
    ⊙-assocₗ : ∀[ P ⊙ (Q ⊙ R) ⇒ (P ⊙ Q) ⊙ R ]
    ⊙-assocₗ (p ∙⟨ σ₁ ⟩ (q ∙⟨ σ₂ ⟩ r)) =
      let _ , σ₃ , σ₄ = ∙-assocₗ σ₁ σ₂ in
      (p ∙⟨ σ₃ ⟩ q) ∙⟨ σ₄ ⟩ r

    ⊙-assocᵣ : ∀[ (P ⊙ Q) ⊙ R ⇒ P ⊙ (Q ⊙ R) ]
    ⊙-assocᵣ ((p ∙⟨ σ₁ ⟩ q) ∙⟨ σ₂ ⟩ r) =
      let _ , σ₃ , σ₄ = ∙-assocᵣ σ₁ σ₂ in
      p ∙⟨ σ₃ ⟩ q ∙⟨ σ₄ ⟩ r

  module _ {p q} {P : Pred A p} {Q : Pred A q} where
    apply : ∀[ P ⊙ (P ─⊙ Q) ⇒ Q ]
    apply (px ∙⟨ sep ⟩ qx) = qx ⟨ sep ⟩ px

  -- mapping
  module _ {p q p' q'}
    {P : Pred A p} {Q : Pred A q} {P' : Pred A p'} {Q' : Pred A q'} where

    ⟨_⟨⊙⟩_⟩ : ∀[ P ⇒ P' ] → ∀[ Q ⇒ Q' ] → ∀[ P ⊙ Q ⇒ P' ⊙ Q' ]
    ⟨_⟨⊙⟩_⟩ f g (px ∙⟨ sep ⟩ qx) = f px ∙⟨ sep ⟩ g qx

  module _ {p q r} {P : Pred A p} {Q : Pred A q} {R : Pred A r} where

    com : ∀[ (P ─⊙ Q) ⊙ (Q ─⊙ R) ⇒ (P ─⊙ R) ]
    com (f ∙⟨ σ₁ ⟩ g) ⟨ σ₂ ⟩ px = let _ , σ₃ , σ₄ = ∙-assocₗ σ₂ σ₁ in g ⟨ σ₄ ⟩ (f ⟨ σ₃ ⟩ px)

  module _ where

    ≤-trans : Φ₁ ≤ Φ₂ → Φ₂ ≤ Φ₃ → Φ₁ ≤ Φ₃
    ≤-trans (τ₁ , Φ₁∙τ₁=Φ₂) (τ₂ , Φ₂∙τ₂=Φ₃) =
      let τ₃ , p , q = ∙-assocᵣ Φ₁∙τ₁=Φ₂ Φ₂∙τ₂=Φ₃ in τ₃ , p

open IsPartialSemigroup {{...}} public
