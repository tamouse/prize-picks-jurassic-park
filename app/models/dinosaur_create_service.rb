# frozen_string_literal: true

# Given a species and name, creates a new dinosaur record and assigns it to the next available cage
class DinosaurCreateService
  include ActiveModel::Validations

  attr_reader :species
  attr_reader :name
  attr_accessor :dinosaur
  attr_accessor :cage

  validates_presence_of :name
  validates_presence_of :species

  validate :persistance_of_dino, on: :create
  validate :persistance_of_cage, on: :create
  validate :validate_assignment, on: :create


  def initialize(species:, name:)
    @species = case species
               when String, Symbol
                 find_species_by_name(name: species)
               when Species
                 species
               else
                 fail 'Not a valid species'
               end

    @name = name
  end

  def create
    return false unless valid?

    self.dinosaur = build_dinosaur
    self.cage = find_suitable_cage

    if dinosaur.save
      dinosaur.create_assignment(cage: @cage)
    end
    validate(:create)
  end

  private

  def build_dinosaur
    Dinosaur.new(
      name: name,
      alive: true,
      species: species,
      vore: species.vore
    )
  end

  def find_species_by_name(name:)
    Species.find_by_name(name)
  end

  def find_suitable_cage
    # Must hold same vore
    cage = Cage.find_by(vore: species.vore)
    if cage.nil?
      # Cage with no assigned species yet
      cage = Cage.find_by(vore: nil)
      if cage.nil?
        # No cages available for this vore
        cage = Cage.create_with_next_number(vore: species.vore)
      else
        # Fill in the vore so no other vores can be assigned
        cage.update(vore: species.vore)
      end
    end
    cage
  end

  def persistance_of_cage
    if cage.nil?
      errors.add(:cage, :blank)
    else
      unless cage.persisted?
        errors.add(:cage, 'not saved')
        cage.errors.full_messages.each do |msg|
          errors.add(:cage, msg)
        end
      end
    end
  end

  def persistance_of_dino
    if dinosaur.nil?
      errors.add(:dinosaur, :blank)
    else
      unless dinosaur.persisted?
        errors.add(:dinosaur, 'not saved')
        dinosaur.errors.full_messages.each do |msg|
          errors.add(:dinosaur, msg)
        end
      end
    end
  end

  def validate_assignment
    return if dinosaur.nil?
    return unless dinosaur.persisted?

    if dinosaur.assignment.nil?
      errors.add(:assignment, :blank)
    else
      unless dinosaur.assignment.persisted?
        errors.add(:assignment, 'not saved')
        dinosaur.assignment.errors.full_messages.each { |msg| errors.add(:assignment, msg) }
      end
    end
  end
end
