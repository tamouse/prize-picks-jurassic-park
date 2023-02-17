# frozen_string_literal: true

require "test_helper"

class CageTest < ActiveSupport::TestCase
  def setup
    @vore = Fabricate :carnivore
  end

  test 'a cage requires as unique number' do
    number = '1234567'

    refute Cage.new(number: nil, vore: @vore).valid?
    refute Cage.new(number: '',  vore: @vore).valid?
    Cage.create!(number:, vore: @vore)
    c2 = Cage.new(number:, vore: @vore)
    refute c2.valid?
    assert c2.errors.details[:number].any? do |detail|
      detail[:error] == :taken
    end
  end

  test 'cage con only hold a single vore' do
    cage = Fabricate :cage
    s1 = Fabricate :carnivore_species, vore: @vore
    d1 = Fabricate :dinosaur, vore: @vore, species: s1, name: 'Betty'
    cage.assignments.create! dinosaur: d1
    cage.save!

    vore2 = Fabricate :herbivore
    s2 = Fabricate :herbivore_species, vore: vore2
    d2 = Fabricate :dinosaur, vore: vore2, species: s2, name: 'Bonnie'
    cage.assignments.create! dinosaur: d2

    refute cage.save
    assert_includes cage.errors.details[:dinosaurs].pluck(:error), 'must all be same vore'
  end

  test "create a cage with a unique number" do
    3.times do |i|
      Cage.create(number: i)
    end
    cage = Cage.create_with_next_number
    assert '3', cage.number
  end
end
