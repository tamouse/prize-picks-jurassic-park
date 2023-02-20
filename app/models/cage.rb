# frozen_string_literal: true

# The cages are numbered, but the numbers are treated as names.
class Cage < ApplicationRecord
  # The maximum number of dinosaurs a cage can hold.
  # Note: In a production environment, this would have to be tunable. This is not the best
  #   place to declare the constant.
  MAX_CAGE_RESIDENTS = ENV['MAX_CAGE_RESIDENTS'] || 3
  POWER_STATUS_ACTIVE = 'active'
  POWER_STATUS_DOWN   = 'down'
  POWER_STATUSES = [POWER_STATUS_ACTIVE, POWER_STATUS_DOWN]

  # Cage's diet doesn't get set until first dinosaur is added
  belongs_to :diet, optional: true
  belongs_to :species, optional: true

  has_many :dinosaurs, dependent: :nullify

  before_validation :update_diet_and_species
  before_validation :normalize_power_status
  validates :number, presence: true, uniqueness: true
  validates :power_status, presence: true, inclusion: { in: POWER_STATUSES }
  validate :compatibility
  validate :not_overfilled
  validate :power_down_with_dinosaurs
  validate :power_up_when_adding_dinosaur

  delegate :herbivore, :herbivore?, :carnivore, :carnivore?, to: :diet, allow_nil: true
  delegate :name, to: :diet, prefix: true, allow_nil: true

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

  def full?
    dinosaurs.length >= MAX_CAGE_RESIDENTS
  end

  def power_down!
    self.power_status = POWER_STATUS_DOWN
    save!
  end

  def power_up!
    self.power_status = POWER_STATUS_ACTIVE
    save!
  end

  private

  def compatibility
    return if dinosaurs.length.zero?
    # Herbivore cages can't hold any carnivores
    # Carnivore cages can only hold one species

    if dinosaurs.joins(:diet).any? { _1.diet != diet }
      errors.add(:dinosaurs, 'must all have same diet')
    elsif carnivore? && dinosaurs.joins(:species).any? { _1.species != species }
      errors.add(:dinosaurs, 'must all be same species when carnivore')
    end
  end
  def get_next_number
    max = self.class.maximum(:number)
    return "0" unless max.present?

    if max[-1].to_s.match(/\d/)
      trailing_number = max.split(/\D+/).last
      max + (trailing_number.to_i + 1).to_s
    else
      max + "0"
    end
  end

  def normalize_power_status
    self.power_status = power_status.empty? ?
                          'active' :
                          normalize_string(power_status)
  end

  def not_overfilled
    if dinosaurs.length > MAX_CAGE_RESIDENTS
      errors.add(:cage, 'has too many residents')
    end
  end

  def power_down_with_dinosaurs
    if power_status == POWER_STATUS_DOWN && dinosaurs.length > 0
      errors.add(:power_status, "can't be powered off if dinosaurs are in cage")
    end
  end

  def power_up_when_adding_dinosaur
    return if changes.fetch('power_status', false)

    unless power_status == POWER_STATUS_ACTIVE
      errors.add(:dinosaurs, "can't be added to a powered off cage")
    end
  end

  def update_diet_and_species
    first = dinosaurs&.first

    self.diet ||= first&.diet
    self.species ||= first&.species
  end
end
