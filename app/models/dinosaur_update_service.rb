# frozen_string_literal: true

class DinosaurUpdateService
  include ActiveModel::Validations

  attr_reader :dinosaur
  attr_reader :name
  attr_reader :alive
  attr_reader :cage_id

  validates_presence_of :dinosaur
  validate :ensure_updates_persisted, on: :update
  validate :ensure_assignment_persisted, on: :update

  def initialize(dinosaur:, name: nil, alive: nil, cage_id: nil)
    @dinosaur = dinosaur
    @name = name
    @alive = alive
    @cage_id = cage_id
  end

  def update
    return unless valid?

    @update_persisted = dinosaur.update(update_params) unless update_params.empty?
    cage_dinosaur

    validate(:update)
  end

  private

  def change_cages?
    cage_id.present? && dinosaur.assignment.cage_id != cage_id
  end

  def cage_dinosaur
    if change_cages?
      @cage_svc = DinosaurToCageService.new(dinosaur: dinosaur, cage_id: cage_id)
      @assignment_persisted = @cage_svc.assign
    else
      @assignment_persisted = nil
    end
  end

  def ensure_assignment_persisted
    return unless cage_id.present?
    return if @assignment_persisted

    errors.add(:assignment, "assign to #{cage_id} failed")

    @cage_svc.errors.full_messages.each { |msg| errors.add(:assignment, msg)} unless @cage_svc.errors.any?
  end

  def ensure_updates_persisted
    return if update_params.empty?
    return if @update_persisted

    errors.add(:dinosaur, 'update failed')
    dinosaur.errors.full_messages.each { |msg| errors.add(:dinosaur, msg)} unless dinosaur.errors.any?
  end

  def update_params
    @update_params ||= {}.tap do |p|
      p[:name] = name if name.present?
      p[:alive] = alive unless alive.nil?
    end
  end
end
