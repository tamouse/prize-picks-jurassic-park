require "test_helper"

class VoreTest < ActiveSupport::TestCase
  test 'validate vore requires a name, name = nil' do
    vore = Vore.new
    refute vore.valid?, 'Oops, vore.name is required'
    refute_empty vore.errors.details[:name]
    assert(vore.errors.details[:name].any? {|name_error| name_error[:error] == :blank}, 'Oops: expecting an error of :blank')
  end

  test 'validate vore requires a name, name = blank' do
    vore = Vore.new(name: '')
    refute vore.valid?, 'Oops, vore.name is required'
    refute_empty vore.errors.details[:name]
    assert(vore.errors.details[:name].any? {|name_error| name_error[:error] == :blank}, 'Oops: expecting an error of :blank')
  end

  test "validate vore name is unique" do
    name = 'Omnivore'
    _v1 = Vore.create!(name: name)
    v2 = Vore.new(name: name)
    refute v2.valid?, 'Oops, vore.name must be unique'
    refute_empty v2.errors.details[:name]
    assert(v2.errors.details[:name].any? {|name_error| name_error[:error] == :taken}, 'Oops: expecting an error of :taken')
  end
end
