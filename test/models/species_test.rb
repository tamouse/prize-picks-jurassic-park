;# frozen_string_literal: true

require 'test_helper'

class SpeciesTest < ActiveSupport::TestCase
  test 'validate species requires a name, name = nil' do
    species = Species.new
    refute species.valid?, 'Oops, species.name is required'
    refute_empty species.errors.details[:name]
    assert(species.errors.details[:name].any? { |e| e[:error] == :blank },
           'Oops: expecting an error of :blank')
  end

  test 'validate species requires a name, name = blank' do
    species = Species.new(name: '')
    refute species.valid?, 'Oops, species.name is required'
    refute_empty species.errors.details[:name]
    assert(species.errors.details[:name].any? { |e| e[:error] == :blank },
           'Oops: expecting an error of :blank')
  end

  test 'validate species name is unique' do
    diet = Fabricate :herbivore
    name = Species::HERBIVORE_SPECIES.sample
    _species1 = Species.create!(name:, diet:)
    species2 = Species.new(name:, diet:)
    refute species2.valid?, 'Oops, species.name must be unique'
    refute_empty species2.errors.details[:name]
    assert(species2.errors.details[:name].any? { |e| e[:error] == :taken },
           'Oops: expecting an error of :taken')
  end
end
