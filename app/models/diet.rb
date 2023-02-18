# frozen_string_literal: true

# What kind of food do you eat?
class Diet < ApplicationRecord
  # NOTE: assignment doesn't call for Omnivores, but we'd add it here if it did
  DIET_TYPES = %w[carnivore herbivore].freeze

  before_validation :slugify_name
  validates :name, presence: true, uniqueness: true, inclusion: { in: DIET_TYPES }

  DIET_TYPES.each do |diet|
    define_method diet.to_sym do
      name == diet
    end
    define_method "#{diet}?".to_sym do
      name == diet
    end
  end
end
