# frozen_string_literal: true

require "test_helper"

class CageTest < ActiveSupport::TestCase
  def setup
    @vore = Fabricate :herbivore
    @species = Fabricate :herbivore_species, vore: @vore
  end

  test 'a cage requires as unique number' do
    number = '1234567'

    refute Cage.new(number: nil, vore: @vore).valid?
    refute Cage.new(number: '',  vore: @vore).valid?
    assert Cage.create(number:, vore: @vore)
    c2 = Cage.new(number:, vore: @vore)
    refute c2.valid?
    assert c2.errors.details[:number].any? { |detail| detail[:error] == :taken }
  end

  test "create a cage with a unique number" do
    3.times do |i|
      Cage.create(number: i)
    end
    cage = Cage.create_with_next_number
    assert '3', cage.number
  end

  test 'verify #dinosaur_counter' do
    create_service = DinosaurCreateService.new(species: @species, name: 'Betty')
    success = create_service.create
    assert success
    cage = create_service.cage
    assert_equal 1, cage.dinosaurs_count
    assert_equal 1, cage.dinosaurs.count
    assert_equal 1, cage.dinosaurs.length
    assert_equal 1, cage.dinosaurs.size

    cage2 = Cage.create_with_next_number(species: @species, vore: @vore)
    update_service = DinosaurUpdateService.new(dinosaur: create_service.dinosaur, cage_id: cage2.id)
    assert update_service.update
    cage.reload
    cage2.reload
    assert_equal cage2, update_service.cage
    assert_equal 1, cage2.dinosaurs_count
    assert_equal 1, cage2.dinosaurs.count
    assert_equal 1, cage2.dinosaurs.length
    assert_equal 1, cage2.dinosaurs.size
    assert_equal 0, cage.dinosaurs_count
    assert_equal 0, cage.dinosaurs.count
    assert_equal 0, cage.dinosaurs.length
    assert_equal 0, cage.dinosaurs.size

  end
end
