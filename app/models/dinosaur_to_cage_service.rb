# frozen_string_literal: true

class DinosaurToCageService
  include ActiveModel::Validations

  attr_reader :dinosaur
  attr_reader :cage

  validates_presence_of :dinosaur
  validates_presence_of :cage, on: :create
  validate on: :assign do
    if dinosaur.cage != cage
      errors.add(:base, 'Assignment of dinosaur #{dinosaur.id} to cage #{cage.id} failed')
    end
  end

  def initialize(dinosaur:, cage: nil)
    @dinosaur = dinosaur
    @cage = cage
  end

  def assign
    return true if dinosaur.cage == cage
    return false unless valid?

    old_cage = dinosaur.cage

    @cage = ensure_cage_is_ready
    return false unless valid?(:create)

    dinosaur.cage = cage
    unless dinosaur.save && cage.save
      dinosaur.errors.full_messages.each { |e| errors.add(:dinosaur, e) } if dinosaur.errors
      dinosaur.update(cage: old_cage)
      cage.errors.full_messages.each { |e| errors.add(:cage, e) } if cage.errors

      return false
    end

    validate(:assign)
  end

  private

  def ensure_cage_is_ready
    return @cage if cage&.persisted? && cage.dinosaurs.length <= Cage::MAX_CAGE_RESIDENTS

    Cage.create_with_next_number(diet: dinosaur.species.diet, species: dinosaur.species)
  end
end
