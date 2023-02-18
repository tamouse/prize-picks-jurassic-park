# frozen_string_literal: true

require "test_helper"

class CageTest < ActiveSupport::TestCase
  def setup
    @diet = Fabricate :herbivore
    @species = Fabricate :herbivore_species, diet: @diet
  end

  test 'a cage requires as unique number' do
    number = '1234567'

    refute Cage.new(number: nil, diet: @diet).valid?
    refute Cage.new(number: '',  diet: @diet).valid?
    assert Cage.create(number:, diet: @diet)
    c2 = Cage.new(number:, diet: @diet)
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

  test 'validate no mixing of herbivores and carnivores' do
    h_diet = @diet
    h_species = @species
    h_dino = Dinosaur.create!(name: 'Marge', species: h_species, diet: h_diet)

    c_diet = Diet.create!(name: :carnivore)
    c_species = Species.create!(name: :velociraptor, diet: c_diet)
    c_dino = Dinosaur.create!(name: 'Mabel', species: c_species, diet: c_diet)

    cage = Cage.create!(number: '2167')

    cage.dinosaurs << h_dino
    assert cage.valid?
    cage.save!

    cage.dinosaurs << c_dino
    refute cage.valid?
  end

  test 'verify #dinosaur_counter' do
    dinosaur = Dinosaur.create!(name: 'Bobbie Joe', species: @species, diet: @diet)
    cage1 = Cage.create!(number: '001', species: @species, diet: @diet)
    cage2 = Cage.create!(number: '002', species: @species, diet: @diet)

    cage1.dinosaurs << dinosaur
    assert cage1.save
    assert_equal 1, cage1.dinosaurs_count
    assert_equal 1, cage1.dinosaurs.count
    assert_equal 1, cage1.dinosaurs.length
    assert_equal 1, cage1.dinosaurs.size

    cage2.dinosaurs << dinosaur
    assert cage2.save

    assert_equal 1, cage2.dinosaurs_count
    assert_equal 1, cage2.dinosaurs.count
    assert_equal 1, cage2.dinosaurs.length
    assert_equal 1, cage2.dinosaurs.size

    cage1.reload
    assert_equal 0, cage1.dinosaurs_count
    assert_equal 0, cage1.dinosaurs.count
    assert_equal 0, cage1.dinosaurs.length
    assert_equal 0, cage1.dinosaurs.size

  end
end
