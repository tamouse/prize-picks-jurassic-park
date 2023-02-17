# frozen_string_literal: true

require 'test_helper'

class DinosaurCreateServiceTest < ActiveSupport::TestCase

  setup do
    @vore = Vore.create(name: :herbivore)
    @species = Species.create(vore: @vore, name: :triceratops)
  end

  teardown do

  end

  test 'can create a service object' do
    assert DinosaurCreateService.new(species: @species, name: 'Polly')
  end

  test "can validate the service object before 'save'" do
    service = DinosaurCreateService.new(species: @species, name: 'Fred')
    assert service.valid?
  end

  test "creates a new dimosaur and puts them in a cage" do
    service = DinosaurCreateService.new(species: @species, name: 'Fred')
    assert service.create
    assert service.dinosaur.persisted?
    assert service.cage.persisted?
    assert_includes service.cage.dinosaurs, service.dinosaur
  end

  test "create a new dinosaur with a species name and puts them in a cage" do
    service = DinosaurCreateService.new(species: :triceratops, name: 'Fred')
    assert service.create
    assert service.dinosaur.persisted?
    assert service.cage.persisted?
    assert_includes service.cage.dinosaurs, service.dinosaur
    assert_equal @species.vore, service.dinosaur.vore
    assert_equal @species.vore, service.cage.vore
  end

  test "can't create a dinosaur with a duplicate name" do
    dino1 = Fabricate :dinosaur, species: @species, vore: @vore
    service = DinosaurCreateService.new(species: @species, name: dino1.name)
    refute service.create
    expected = {
      dinosaur: [
        { error: "not saved" },
        { error: "Name has already been taken"}
      ]
    }
    assert_equal expected, service.errors.details
  end
end
