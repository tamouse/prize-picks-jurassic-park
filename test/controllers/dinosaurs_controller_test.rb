# frozen_string_literal: true

require "test_helper"

class DinosaursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @species = Fabricate :species
    @cage = Fabricate :cage, vore: @species.vore
    @dinosaur = Fabricate :dinosaur, species: @species, vore: @species.vore
  end

  test "should get index" do
    get dinosaurs_url, as: :json
    assert_response :success
  end

  test "should create dinosaur" do
    new_dino = Fabricate.attributes_for :dinosaur, species: @species, vore: @species.vore
    assert_difference("Dinosaur.count") do
      post dinosaurs_url,
           params: {
             dinosaur: {
               alive: new_dino[:alive],
               name: new_dino[:name],
               species_id: new_dino[:species_id],
               vore_id: new_dino[:vore_id]
             }
           },
           as: :json
    end

    assert_response :created
  end

  test "should show dinosaur" do
    get dinosaur_url(@dinosaur), as: :json
    assert_response :success
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
