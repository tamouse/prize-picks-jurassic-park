# frozen_string_literal: true

# The cages are numbered, but the numbers are treated as names.
class Cage < ApplicationRecord
  # Cage's vore doesn't get set until first dinosaur is added
  belongs_to :vore, optional: true
  has_many :assignments, dependent: :destroy, autosave: true
  has_many :dinosaurs, through: :assignments

  before_validation :update_vore
  validates :number, presence: true, uniqueness: true
  validate :same_vore_all_members

  private

  def same_vore_all_members
    return if assignments.empty?

    vore = dinosaurs.first.vore
    return if dinosaurs.joins(:vore).where.not(vore: vore).empty?

    errors.add(:dinosaurs, 'must all be same vore')
  end

  def update_vore
    self.vore = dinosaurs.empty? ? nil : dinosaurs.first.vore
  end
end
