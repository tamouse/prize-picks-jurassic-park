# frozen_string_literal: true

require "test_helper"

class DinosaursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @species = Fabricate :species
    @cage = Fabricate :cage, diet: @species.diet, species: @species
    @dinosaur = Fabricate :dinosaur, species: @species, diet: @species.diet
  end

  test "should get index" do
    get dinosaurs_url, as: :json
    assert_response :success
  end

  test "should create dinosaur" do
    new_dino = Fabricate.attributes_for :dinosaur, species: @species, diet: @species.diet
    assert_difference("Dinosaur.count") do
      post dinosaurs_url,
           params: {
             dinosaur: {
               name: new_dino[:name],
               species_id: new_dino[:species_id]
             }
           },
           as: :json
    end

    assert_response :created
  end

  test "should give an error when duplicate name chosen" do
    assert_no_difference("Dinosaur.count") do
      post dinosaurs_url,
           params: {
             dinosaur: {
               name: @dinosaur.name,
               species_id: @species.id
             }
           },
           as: :json

      assert_response :unprocessable_entity
    end

  end

  test "should show dinosaur" do
    get dinosaur_url(@dinosaur), as: :json
    assert_response :success
  end

  test "can move a dinosaur to a different cage" do
    service = DinosaurToCageService.new(dinosaur: @dinosaur, cage: @cage)
    assert service.assign
    assert_equal @cage, @dinosaur.cage

    @new_cage = Fabricate :cage, diet: @species.diet, species: @species


    patch move_dinosaur_url(@dinosaur), params: { dinosaur: { cage_id: @new_cage.id}}
    assert_response :success

    @dinosaur.reload
    @cage.reload
    @new_cage.reload
    refute_equal @cage, @dinosaur.cage
    assert_equal @new_cage, @dinosaur.cage
  end

  test "cannot move a dinosaur to a powered down cage" do
    service = DinosaurToCageService.new(dinosaur: @dinosaur, cage: @cage)
    assert service.assign
    assert_equal @cage, @dinosaur.cage

    @new_cage = Fabricate :cage, diet: @species.diet, species: @species, power_status: 'down'

    patch move_dinosaur_url(@dinosaur), params: { dinosaur: { cage_id: @new_cage.id}}
    assert_response :unprocessable_entity

    @dinosaur.reload
    @cage.reload
    @new_cage.reload
    refute_equal @new_cage, @dinosaur.cage
    assert_equal @cage, @dinosaur.cage
  end

  test "should update dinosaur" do
    patch dinosaur_url(@dinosaur), params: { dinosaur: { alive: !@dinosaur.alive } }, as: :json
    assert_response :success
  end

  test "should destroy dinosaur" do
    assert_difference("Dinosaur.count", -1) do
      delete dinosaur_url(@dinosaur), as: :json
    end

    assert_response :no_content
  end
end
