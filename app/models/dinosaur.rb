# frozen_string_literal: true

# Tne wee beasties! Rahr!
class Dinosaur < ApplicationRecord
  belongs_to :species
  belongs_to :vore
  belongs_to :cage

  validates :name, presence: true, uniqueness: true
end
