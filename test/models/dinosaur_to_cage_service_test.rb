# frozen_string_literal: true

require 'test_helper'

class DinosaurToCageServiceTest < ActiveSupport::TestCase

  setup do
    diet = Fabricate :diet
    species = Fabricate :species, diet: diet
    @cage = Fabricate :cage, species: species, diet: diet
    @new_cage = Fabricate :cage, species: species, diet: diet
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

  test 'can move dinosaurs to a different cage' do
    service = DinosaurToCageService.new(dinosaur: @dinosaur, cage: @new_cage)
    assert service.assign, "oops: service.errors: #{service.errors.details.inspect}"
    assert_equal @new_cage, @dinosaur.cage
  end

end
