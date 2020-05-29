module Everything where

-- Core defines what a ternary relation (Rel₃) in Set is.
import Relation.Ternary.Core
-- Having defined a ternary (homogeneous) relation you get the usual connectives from separation logic
-- like _✴_ (\st 5) and the adjoint wand _─✴_ (\---\st).

-- Then there is a hierarchy of structures that you can prove for such a relation.
-- The main ones are:
--    ∙ IsPartialSemigroup _≈_ rel₃ 
--    ∙ IsPartialMonoid    _≈_ rel₃ ε
--    ∙ IsCommutative      rel₃
-- Additionally there are various other mixins, like:
--    ∙ IsTotal            _≈_ rel _∙_ (proving there is always at least 1 composition)
--    ∙ IsContractive      _≈_ rel     (proving xs ∙ xs ≣ xs)
--    ∙ IsFunctional       _≈_ rel
--    ∙ IsPositive         _≈_ rel     (proving that splittings make things smaller)
import Relation.Ternary.Structures

-- As you prove lemmas about your ternary relation, you gain lots of utilities for using the ✴ and ─✴.
-- E.g., proving it a partial semigroup gives you `✴-curry : ∀[ (P ─✴ (Q ─✴ R)) ⇒ (P ✴ Q) ─✴ R ]`
-- and transitivity of the extension order of the relation.
-- Proving it commutative yields rotation lemmas `✴-rotateᵣ : ∀[ P ✴ Q ✴ R ⇒ R ✴ P ✴ Q ]`.

-- Typically, the easiest way to use this library is to define your relation and the structures
-- as `instance`s. You can then import the overloaded syntax and let instance search to the hard work.
-- This works well if you don't have multiple relations on a single carrier at the same time.
import Relation.Ternary.Structures.Syntax

-- On top of these structures we can define some common data structures,
-- making them 'resource' aware by replacing products by ✴:
import Relation.Ternary.Data.Bigstar             -- like Data.List
import Relation.Ternary.Data.Allstar             -- like Data.List.Relation.All
import Relation.Ternary.Data.ReflexiveTransitive -- like Data.Star

-- The same, but for computational structures:
import Relation.Ternary.Functor
import Relation.Ternary.Monad
import Relation.Ternary.Comonad
