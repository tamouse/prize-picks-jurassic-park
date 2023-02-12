# frozen_string_literal: true

require 'test_helper'

class DinosaurTest < ActiveSupport::TestCase
  test 'validations should work' do
    d = Dinosaur.new
    refute d.valid?, 'Oops, new empty record should be invalid'
    refute_empty d.errors.details[:name]
    refute_empty d.errors.details[:species]
    refute_empty d.errors.details[:vore]
  end

  test 'fabricator should work' do
    d = Fabricate.build :dinosaur
    assert d.valid?
    assert_empty d.errors
  end
end
