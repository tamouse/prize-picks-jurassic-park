# frozen_string_literal: true

# Tne wee beasties! Rahr!
class Dinosaur < ApplicationRecord
  belongs_to :diet
  belongs_to :species
  belongs_to :cage, optional: true, counter_cache: true

  validates :name, presence: true, uniqueness: true

  delegate :herbivore, :herbivore?, :carnivore, :carnivore?, to: :diet, allow_nil: true
end
