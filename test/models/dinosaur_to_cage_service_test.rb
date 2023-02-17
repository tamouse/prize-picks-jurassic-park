# frozen_string_literal: true

require 'test_helper'

class DinosaurToCageServiceTest < ActiveSupport::TestCase

  setup do
    vore = Fabricate :vore
    species = Fabricate :species, vore: vore
    @cage = Fabricate :cage
    @new_cage = Fabricate :cage
    @dinosaur = Fabricate :dinosaur, species: species, vore: vore
    @dinosaur.create_assignment(cage: @cage)
  end

  teardown do

  end

  test 'can initialize the service' do
    service = DinosaurToCageService.new(dinosaur: @dinosaur, cage_id: @new_cage.id)
    assert service.present?
    assert service.dinosaur.present?
  end

end
