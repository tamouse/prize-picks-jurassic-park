require "test_helper"

class CagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cage = Fabricate :cage
  end

  test "should get index" do
    get cages_url, as: :json
    assert_response :success
  end

  test "should create cage" do
    new_cage = Fabricate.attributes_for :cage
    assert_difference("Cage.count") do
      post cages_url, params: { cage: { number: new_cage['number'], vore_id: new_cage['vore_id'] } }, as: :json
    end

    assert_response :created
  end

  test "should show cage" do
    get cage_url(@cage), as: :json
    assert_response :success
  end

  test "should update cage" do
    patch cage_url(@cage), params: { cage: { number: @cage.number + 'bis' } }, as: :json
    assert_response :success
  end

  test "should destroy cage" do
    assert_difference("Cage.count", -1) do
      delete cage_url(@cage), as: :json
    end

    assert_response :no_content
  end
end
