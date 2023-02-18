# frozen_string_literal: true

require 'test_helper'

class DinosaurUpdateServiceTest < ActiveSupport::TestCase

  setup do
    diet = Fabricate :diet
    species = Fabricate :species, diet: diet
    @cage = Fabricate :cage, diet: diet, species: species
    @dinosaur = Fabricate :dinosaur, species: species, diet: diet
    to_cage_svc = DinosaurToCageService.new(dinosaur: @dinosaur, cage: @cage)
    assert to_cage_svc.assign, "oops, to_cage_svc errors, #{to_cage_svc.errors.full_messages.join("\n")}"
  end

  test "can initialize the service" do
    service = DinosaurUpdateService.new(dinosaur: @dinosaur)
    assert service.present?
    assert service.dinosaur.present?
    assert service.cage.present?
  end

  test "can change the name" do
    new_name = @dinosaur.name * 2
    old_alive = @dinosaur.alive
    old_cage = @dinosaur.cage
    service = DinosaurUpdateService.new(dinosaur: @dinosaur, name: new_name)
    assert service.update, "oops: errors: #{service.errors.full_messages.join("\n")}"
    assert_equal new_name, @dinosaur.reload.name
    assert_equal old_alive, @dinosaur.alive
    assert_equal old_cage, @dinosaur.cage
  end

  test "can change the aliveness" do
    old_name = @dinosaur.name
    new_alive = !@dinosaur.alive
    old_cage = @dinosaur.cage
    service = DinosaurUpdateService.new(dinosaur: @dinosaur, alive: new_alive)

    assert service.update, "oops: errors: #{service.errors.full_messages.join("\n")}"
    assert_equal old_name, @dinosaur.reload.name
    assert_equal new_alive, @dinosaur.alive
    assert_equal old_cage, @dinosaur.cage
  end

  test "can change the cage" do
    old_name = @dinosaur.name
    old_alive = @dinosaur.alive
    old_cage = @dinosaur.cage
    new_cage = Fabricate :cage, diet: @dinosaur.species.diet, species: @dinosaur.species

    service = DinosaurUpdateService.new(dinosaur: @dinosaur, cage_id: new_cage.id)

    assert service.update, "oops: errors: #{service.errors.full_messages.join("\n")}"
    assert_equal old_name, @dinosaur.reload.name
    assert_equal old_alive, @dinosaur.alive
    refute_equal old_cage, @dinosaur.cage
  end

end
