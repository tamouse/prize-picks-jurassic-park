class Assignment < ApplicationRecord
  belongs_to :dinosaur
  belongs_to :cage

  validate :cage_dinosaur_compatibility

  private

  def cage_dinosaur_compatibility
    # Herbivore cages can't hold any carnivores
    # Conivore cages can only hold one species
    cage = Cage.find cage_id
    dinosaurs = cage.dinosaurs
    species = cage.species
    vore = cage.vore

    return if dinosaurs.joins(:vore).all? { _1.vore == vore }
    errors.add(:cage, 'must all be same vore')

    return if cage.carnivore? && dinosaurs.joins(:species).all? { _1.species == species }
    errors.add(:cage, 'must be different species')
  end

end
