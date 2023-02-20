require "test_helper"

class CagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cage = Fabricate :cage
  end

  test "should get index" do
    get cages_url, as: :json
    assert_response :success
    index = JSON.parse(response.body)['cages']
    assert(index, "oops: data recieved: #{response.body}")
    assert_equal(1, index.length)
  end

  test "should create cage" do
    new_cage = Fabricate.attributes_for :cage
    assert_difference("Cage.count") do
      post cages_url, params: { cage: { number: new_cage['number']} }, as: :json
    end

    assert_response :created
    cage = JSON.parse(response.body)['cage']
    assert( cage, "oops: #{response.body}")
    assert_equal(new_cage['number'], cage['number'], "oops: data sent: #{new_cage.inspect}, data receoved: #{cage.inspect}")
  end

  test "should show cage" do
    get cage_url(@cage), as: :json
    assert_response :success
    shown_cage = JSON.parse(response.body)['cage']
    assert(shown_cage, "oops: data received: #{response.body}")
    assert_equal(@cage.id, shown_cage['id'])
  end

  test "should update cage" do
    patch cage_url(@cage), params: { cage: { number: @cage.number + 'bis' } }, as: :json
    assert_response :success
    updated_cage = JSON.parse(response.body)['cage']
    assert(updated_cage, "oops: data received: #{response.body}")
    refute_equal(@cage.number, updated_cage['number'], "oops: original cage: #{@cage.as_json.inspect} data received: #{updated_cage}")
  end

  test "should destroy cage" do
    assert_difference("Cage.count", -1) do
      delete cage_url(@cage), as: :json
    end

    assert_response :no_content
    assert_empty response.body
  end
end
