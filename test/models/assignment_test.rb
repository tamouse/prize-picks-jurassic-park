require "test_helper"

class AssignmentTest < ActiveSupport::TestCase
  setup do
    @vore = Vore.create!(name: :carnivore)
    @species = Species.create!(name: Species::CARNIVORE_SPECIES[0], vore: @vore)
    @cage = Cage.create!(number: 'cage0')
    @dinosaur = Dinosaur.create!(species: @species, vore: @vore, name: 'Betty')
  end

  test 'can assign a dinosaur to a cage' do
    @dinosaur.create_assignment(cage: @cage)
    assert_equal @cage, @dinosaur.assignment.cage
    assert_equal @cage, @dinosaur.cage
  end

  test 'can assign a cage to a dinosaur' do
    assert @cage.assignments.create(dinosaur: @dinosaur)
    assignments = @cage.assignments.where(cage: @cage)
    assert_equal 1, assignments.length
    asssignment = assignments.first
    assert_equal @dinosaur, asssignment.dinosaur
  end

  test "only make assignments when dinosaur and cage are compatible" do
    _assignment1 = Assignment.create!(cage: @cage, dinosaur: @dinosaur)

    species2 = Species.create!(name: Species::CARNIVORE_SPECIES[1], vore: @vore)
    dinosaur2 = Dinosaur.create!(species: species2, vore: @vore, name: 'Susie')
    assignment2 = Assignment.new(cage: @cage, dinosaur: dinosaur2)

    refute assignment2.valid?
    dinosaur2.reload
    assert_nil dinosaur2.assignment
  end
end
