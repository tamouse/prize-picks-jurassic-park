# frozen_string_literal: true

# Tne wee beasties! Rahr!
class Dinosaur < ApplicationRecord
  belongs_to :diet
  belongs_to :species
  belongs_to :cage, optional: true, counter_cache: true

  validates :name, presence: true, uniqueness: true

  delegate :herbivore, :herbivore?, :carnivore, :carnivore?, to: :diet
  delegate :name, to: :diet, prefix: true # diet_name
  delegate :name, to: :species, prefix: true # species_name
  delegate :number, to: :cage, allow_nil: true, prefix: true # cage_number
end
