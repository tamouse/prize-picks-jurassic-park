# frozen_string_literal: true

# Tne wee beasties! Rahr!
class Dinosaur < ApplicationRecord
  belongs_to :vore
  belongs_to :species

  has_one :assignment, dependent: :destroy, autosave: true
  # has_one :cage, through: :assignment

  validates :name, presence: true, uniqueness: true

  delegate :cage, to: :assignment, allow_nil: true
end
