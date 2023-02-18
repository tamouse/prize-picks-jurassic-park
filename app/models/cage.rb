# frozen_string_literal: true

# The cages are numbered, but the numbers are treated as names.
class Cage < ApplicationRecord
  # The maximum number of dinosaurs a cage can hold.
  # Note: In a production environment, this would have to be tunable. This is not the best
  #   place to declare the constant.
  MAX_CAGE_RESIDENTS = ENV['MAX_CAGE_RESIDENTS'] || 3

  # Cage's diet doesn't get set until first dinosaur is added
  belongs_to :diet, optional: true
  belongs_to :species, optional: true

  has_many :dinosaurs, dependent: :nullify

  before_validation :update_diet_and_species
  validates :number, presence: true, uniqueness: true
  validate :compatibility
  validate :not_overfilled

  delegate :herbivore, :herbivore?, :carnivore, :carnivore?, to: :diet, allow_nil: true

  def self.create_with_next_number(**kwargs)
    new.create_with_next_number(**kwargs)
  end

  def create_with_next_number(**kwargs)
    number = kwargs.delete(:number)
    assign_attributes(**kwargs) unless kwargs.empty?
    if number.nil?
      self.number = get_next_number
    end
    self if save
  end

  private

  def compatibility
    return if dinosaurs.count.zero?
    # Herbivore cages can't hold any carnivores
    # Carnivore cages can only hold one species

    unless dinosaurs.joins(:diet).all? { _1.diet == diet }
      errors.add(:dinosaurs, 'must all have same diet')
      return
    end

    if :carnivore? && dinosaurs.joins(:species).all? { _1.species != species }
      errors.add(:dinosaurs, 'must all be same species when carnivore')
    end
  end

  def not_overfilled
    if dinosaurs.length > MAX_CAGE_RESIDENTS
      errors.add(:cage, 'has too many residents')
    end
  end

  def get_next_number
    max = self.class.maximum(:number)
    return "0" unless max.present?

    if max[-1].match(/\d/)
      max.split(/[^\d]+/).last.to_i + 1
    else
      max + "0"
    end
  end

  def update_diet_and_species
    self.diet ||= dinosaurs.empty? ? nil : dinosaurs.first.diet
    self.species ||= dinosaurs.empty? ? nil : dinosaurs.first.species
  end
end
