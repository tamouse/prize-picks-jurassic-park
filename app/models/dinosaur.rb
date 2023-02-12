# frozen_string_literal: true

# Tne wee beasties! Rahr!
class Dinosaur < ApplicationRecord
  belongs_to :species
  belongs_to :vore
  has_one :assignment
  has_one :cage, through: :assignment

  validates :name, presence: true, uniqueness: true
end
