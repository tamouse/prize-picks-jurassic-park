require "test_helper"

class AssignmentTest < ActiveSupport::TestCase
  setup do
    @vore = Fabricate :vore
    @species = Fabricate :species, vore: @vore
    @cage = Fabricate :cage

    @dinosaur = Fabricate :dinosaur, species: @species, vore: @vore
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
end
