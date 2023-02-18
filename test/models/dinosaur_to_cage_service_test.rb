# frozen_string_literal: true

require 'test_helper'

class DinosaurToCageServiceTest < ActiveSupport::TestCase

  setup do
    diet = Fabricate :diet
    species = Fabricate :species, diet: diet
    @cage = Fabricate :cage
    @new_cage = Fabricate :cage
    @dinosaur = Fabricate :dinosaur, species: species, diet: diet
  end

  teardown do

  end

  test 'can initialize the service' do
    service = DinosaurToCageService.new(dinosaur: @dinosaur, cage: @cage)
    assert service.present?
    assert service.dinosaur.present?
    assert service.cage.present?
  end

  test 'can move dinosaurs to a differnt cage' do
    service = DinosaurToCageService.new(dinosaur: @dinosaur, cage: @cage)
    assert service.assign
    assert_equal @cage, @dinosaur.cage
  end

end
