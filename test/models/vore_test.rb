# frozen_string_literal: true

require 'test_helper'

class VoreTest < ActiveSupport::TestCase
  test 'validate vore requires a name, name = nil' do
    vore = Vore.new
    refute vore.valid?, 'Oops, vore.name is required'
    refute_empty vore.errors.details[:name]
    assert(vore.errors.details[:name].any? { |e| e[:error] == :blank },
           'Oops: expecting an error of :blank')
  end

  test 'validate vore requires a name, name = blank' do
    vore = Vore.new(name: '')
    refute vore.valid?, 'Oops, vore.name is required'
    refute_empty vore.errors.details[:name]
    assert(vore.errors.details[:name].any? { |e| e[:error] == :blank },
           'Oops: expecting an error of :blank')
  end

  test 'validate vore name is unique' do
    name = :herbivore
    _v1 = Vore.create!(name:)
    v2 = Vore.new(name:)
    refute v2.valid?, 'Oops, vore.name must be unique'
    refute_empty v2.errors.details[:name]
    assert(v2.errors.details[:name].any? { |e| e[:error] == :taken },
           'Oops: expecting an error of :taken')
  end

  test "#herbivore" do
    vore1 = Vore.create!(name: :herbivore)
    vore2 = Vore.create!(name: :carnivore)

    assert vore1.herbivore
    assert vore1.herbivore?
    refute vore2.herbivore
    refute vore2.herbivore?
  end

  test "#carnivore" do
    vore1 = Vore.create!(name: :carnivore)
    vore2 = Vore.create!(name: :herbivore)

    assert vore1.carnivore
    assert vore1.carnivore?
    refute vore2.carnivore
    refute vore2.carnivore?
  end

end
