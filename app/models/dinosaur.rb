# frozen_string_literal: true

# Tne wee beasties! Rahr!
class Dinosaur < ApplicationRecord
  belongs_to :vore
  belongs_to :species
  belongs_to :cage, optional: true

  validates :name, presence: true, uniqueness: true

  delegate :herbivore, :herbivore?, :carnivore, :carnivore?, to: :vore, allow_nil: true
end
