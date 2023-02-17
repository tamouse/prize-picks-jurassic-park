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
end
