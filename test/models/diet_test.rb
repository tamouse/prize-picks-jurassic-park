# frozen_string_literal: true

require 'test_helper'

class DietTest < ActiveSupport::TestCase
  test 'validate diet requires a name, name = nil' do
    diet = Diet.new
    refute diet.valid?, 'Oops, diet.name is required'
    refute_empty diet.errors.details[:name]
    assert(diet.errors.details[:name].any? { |e| e[:error] == :blank },
           'Oops: expecting an error of :blank')
  end

  test 'validate diet requires a name, name = blank' do
    diet = Diet.new(name: '')
    refute diet.valid?, 'Oops, diet.name is required'
    refute_empty diet.errors.details[:name]
    assert(diet.errors.details[:name].any? { |e| e[:error] == :blank },
           'Oops: expecting an error of :blank')
  end

  test 'validate diet name is unique' do
    name = :herbivore
    _v1 = Diet.create!(name:)
    v2 = Diet.new(name:)
    refute v2.valid?, 'Oops, diet.name must be unique'
    refute_empty v2.errors.details[:name]
    assert(v2.errors.details[:name].any? { |e| e[:error] == :taken },
           'Oops: expecting an error of :taken')
  end

  test "#herbivore" do
    diet1 = Diet.create!(name: :herbivore)
    diet2 = Diet.create!(name: :carnivore)

    assert diet1.herbivore
    assert diet1.herbivore?
    refute diet2.herbivore
    refute diet2.herbivore?
  end

  test "#carnivore" do
    diet1 = Diet.create!(name: :carnivore)
    diet2 = Diet.create!(name: :herbivore)

    assert diet1.carnivore
    assert diet1.carnivore?
    refute diet2.carnivore
    refute diet2.carnivore?
  end

end
