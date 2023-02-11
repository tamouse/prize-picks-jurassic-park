# frozen_string_literal: true

# The cages are numbered, but the numbers are treated as names.
class Cage < ApplicationRecord
  # Forces the rule that a cage can contain only a single type of vore
  belongs_to :vore
  has_many :dinosaurs, dependent: :nullify

  # TODO: Specify the relation with Dinosaurs and Cages as Assignments

  validates :number, presence: true, uniqueness: true
  validate :same_vore_all_members

  private

  def same_vore_all_members
    return if dinosaurs.blank?

    vore = dinosaurs.first.vore
    errors.add(:dinosaurs, 'must all be same vore') unless dinosaurs.all? do |d|
      d.vore == vore
    end
  end
end
