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

  def get_next_number
    max = self.class.maximum(:number)
    return "0" unless max.present?

    if max[-1].match(/\d/)
      max.split(/[^\d]+/).last.to_i + 1
    else
      max + "0"
    end
  end

  def same_vore_all_members
    return if assignments.empty?

    vore = dinosaurs.first.vore
    return if dinosaurs.joins(:vore).where.not(vore: vore).empty?

    errors.add(:dinosaurs, 'must all be same vore')
  end

  def update_vore
    self.vore ||= dinosaurs.empty? ? nil : dinosaurs.first.vore
  end
end
