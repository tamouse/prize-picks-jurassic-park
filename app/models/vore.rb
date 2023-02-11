# frozen_string_literal: true

# What kind of food do you eat?
class Vore < ApplicationRecord
  # NOTE: assignment doesn't call for Omnivores, but we'd add it here if it did
  VORE_TYPES = %w[carnivore herbivore].freeze

  before_validation :slugify_name
  validates :name, presence: true, uniqueness: true, inclusion: { in: VORE_TYPES }
end
