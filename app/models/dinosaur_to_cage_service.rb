# frozen_string_literal: true

class DinosaurToCageService
  include ActiveModel::Validations

  attr_reader :dinosaur
  attr_reader :cage

  validates_presence_of :dinosaur
  validates_presence_of :cage, on: :create
  validate on: :assign do
    if dinosaur.cage != cage
      errors.add(:base, 'assignment of dinosaur #{dinosaur.id} to cage #{cage.id} failed')
    end
  end

  def initialize(dinosaur:, cage: nil)
    @dinosaur = dinosaur
    @cage = cage
  end

  def assign
    return true if dinosaur.cage = cage
    return false unless valid?

    @cage = ensure_cage_is_ready
    return false unless valid?(:create)

    unless dinosaur.update(cage_id: cage.id)
      dinosaur.errors.full_messages.each { |e| errors.add(:dinosaur, e) }
      return false
    end

    validate(:assign)
  end

  private

  def ensure_cage_is_ready
    return cage if cage.persisted?

    Cage.create_with_next_number(vore: dinosaur.species.vore, species: dinosaur.species)
  end
end
