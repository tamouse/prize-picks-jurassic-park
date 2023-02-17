# frozen_string_literal: true

class DinosaurToCageService
  include ActiveModel::Validations

  attr_reader :dinosaur
  attr_reader :cage_id
  attr_reader :cage

  validates_presence_of :dinosaur

  def initialize(dinosaur:, cage_id: nil)
    @dinosaur = dinosaur
    @cage_id = cage_id
  end

  def assign
    return true if dinosaur.assignment&.cage_id == cage_id
    return false unless valid?

    @cage = ensure_cage_is_ready
    unless cage.persisted?
      errors.add(:cage, 'not present')
      return false
    end

    ApplicationRecord.transaction do
      dinosaur.assignment&.destroy
      dinosaur.create_assignment(cage: cage)
      if cage.vore_id.nil?
        cage.update(vore: dinosaur.vore)
      end
    end

    return true if dinosaur.assignment.cage == cage
  end

  private

  def ensure_cage_is_ready
    if cage_id.nil?
      Cage.create_with_next_number
    else
      Cage.find_by(id: cage_id)
    end
  end
end
