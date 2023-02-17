# frozen_string_literal: true

class DinosaurUpdateService
  include ActiveModel::Validations

  attr_reader :dinosaur
  attr_reader :name
  attr_reader :alive
  attr_reader :cage_id
  attr_reader :cage

  validates_presence_of :dinosaur, :cage
  validate on: :update do
    unless @update_succeeded
      errors.add(:base, 'update failed')
      dinosaur.errors.full_messages.each { |e| errors.add(:dinosaur, e) } unless dinosaur.errors.empty?
      cage.errors.full_messages.each { |e| errors.add(:cage, e) } unless cage.errors.empty?
    end
  end

  def initialize(dinosaur:, name: nil, alive: nil, cage_id: nil)
    @dinosaur = dinosaur
    @name = name
    @alive = alive
    @cage_id = cage_id
    @cage = Cage.find_by(id: cage_id)
    @cage = Cage.create_with_next_number(vore: dinosaur.species.vore, species: dinosaur.species) if @cage.nil?
  end

  def update
    return unless valid?

    @update_succeeded = false
    unless update_params.empty?
      if dinosaur.update(update_params)
        @update_succeeded = true
      else
        @update_succeeded = false
      end
    end

    unless cage_id.nil?
      if cage_dinosaur
        @update_succeeded = true
      else
        @update_succeeded = false
      end
    end

    validate(:update)
  end

  private

  def cage_dinosaur
    return true if dinosaur.cage == cage

    @cage_svc = DinosaurToCageService.new(dinosaur: dinosaur, cage: cage)
    success = @cage_svc.assign
    @cage_svc.errors.full_messages.each { |e| errors.add(:dinosaur_to_cage_service, e) } unless success
    success
  end

  def update_params
    @update_params ||= {}.tap do |p|
      p[:name] = name if name.present?
      p[:alive] = alive unless alive.nil?
    end
  end
end
