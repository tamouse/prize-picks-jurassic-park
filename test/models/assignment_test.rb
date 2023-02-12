require "test_helper"

class AssignmentTest < ActiveSupport::TestCase
  setup do
    vore = Fabricate :vore
    species = Fabricate :species, vore: vore
    @cage = Fabricate :cage, vore: vore
    @dinosaur = Fabricate :dinosaur, cage: nil, species: species, vore: vore
  end

  test "can assign a dinosaur to a cage" do
    @dinosaur.cage = @cage
    assert @dinosaur.valid?
  end
end
