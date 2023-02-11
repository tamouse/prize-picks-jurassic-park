# frozen_string_literal: true

require "test_helper"

class CageTest < ActiveSupport::TestCase
  def setup
    @vore = Fabricate :vore
  end

  test "a cage requires as unique number" do
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
end
