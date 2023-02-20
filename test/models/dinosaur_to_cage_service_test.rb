# frozen_string_literal: true

require 'test_helper'

class DinosaurToCageServiceTest < ActiveSupport::TestCase

  setup do
    diet = Fabricate :diet
    species = Fabricate :species, diet: diet
    @cage = Fabricate :cage, species: species, diet: diet
    @new_cage = Fabricate :cage
    @dinosaur = Fabricate :dinosaur, species: species, diet: diet
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

  test 'cannot move dinosaurs to a different cage if powered down' do
    assert @new_cage.power_down!
    service = DinosaurToCageService.new(dinosaur: @dinosaur, cage: @new_cage)
    refute service.assign
    refute_equal @new_cage, @dinosaur.reload.cage, "oops: service.errors: #{service.errors.details.inspect}"
  end

  test "can assign a new cage with no species or diet assigned yet" do
    service = DinosaurToCageService.new(dinosaur: @dinosaur, cage: @new_cage)
    assert service.assign
    assert_equal @new_cage, @dinosaur.reload.cage, "oops: service.errors: #{service.errors.details.inspect}"
  end

  test "can create a new cage when necessary" do
    service = DinosaurToCageService.new(dinosaur: @dinosaur, cage: nil)
    assert service.assign
  end
end
