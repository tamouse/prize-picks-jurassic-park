# frozen_string_literal: true

require 'test_helper'

class DinosaurUpdateServiceTest < ActiveSupport::TestCase

  setup do
    vore = Fabricate :vore
    species = Fabricate :species, vore: vore
    @cage = Fabricate :cage
    @dinosaur = Fabricate :dinosaur, species: species, vore: vore
    @dinosaur.create_assignment(cage: @cage)
  end

  test "can initialize the service" do
    service = DinosaurUpdateService.new(dinosaur: @dinosaur)
    assert service.present?
    assert service.dinosaur.present?
  end

  test "can change the name" do
    new_name = @dinosaur.name * 2
    old_alive = @dinosaur.alive
    old_assignment = @dinosaur.assignment

    service = DinosaurUpdateService.new(dinosaur: @dinosaur, name: new_name)

    assert service.update
    assert_equal new_name, @dinosaur.reload.name
    assert_equal old_alive, @dinosaur.alive
    assert_equal old_assignment, @dinosaur.assignment
  end

  test "can change the aliveness" do
    old_name = @dinosaur.name
    new_alive = !@dinosaur.alive
    old_assignment = @dinosaur.assignment
    service = DinosaurUpdateService.new(dinosaur: @dinosaur, alive: new_alive)

    assert service.update
    assert_equal old_name, @dinosaur.reload.name
    assert_equal new_alive, @dinosaur.alive
    assert_equal old_assignment, @dinosaur.assignment
  end

  test "can change the cage" do
    old_name = @dinosaur.name
    old_alive = @dinosaur.alive
    old_assignment = @dinosaur.assignment
    new_cage = Fabricate :cage

    service = DinosaurUpdateService.new(dinosaur: @dinosaur, cage_id: new_cage.id)

    assert service.update
    assert_equal old_name, @dinosaur.reload.name
    assert_equal old_alive, @dinosaur.alive
    refute_equal old_assignment.cage_id, @dinosaur.assignment.cage_id
  end

end
