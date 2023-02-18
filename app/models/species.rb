# frozen_string_literal: true

# Species is a singular / plural word
class Species < ApplicationRecord
  CARNIVORE_SPECIES = %w[tyrannosaurus velociraptor spinosaurus megalosaurus].freeze
  HERBIVORE_SPECIES = %w[brachiosaurus stegosaurus ankylosaurus triceratops].freeze
  ALL_SPECIES = CARNIVORE_SPECIES + HERBIVORE_SPECIES

  belongs_to :diet

  before_validation :slugify_name
  validates :name, presence: true, uniqueness: true, inclusion: { in: ALL_SPECIES }

  delegate :herbivore, :herbivore?, :carnivore, :carnivore?, to: :diet, allow_nil: true
end
