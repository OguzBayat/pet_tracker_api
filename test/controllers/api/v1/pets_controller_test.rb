require "test_helper"

class Api::V1::PetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pet = create(:pet)
  end

  test "should get index" do
    get api_v1_pets_url, as: :json
    assert_response :success
  end

  test "should create pet" do
    assert_difference("Pet.count") do
      post api_v1_pets_url, params: { pet: {
        type: "Cat",
        tracker_type: "small",
        owner_id: 1,
        in_zone: true,
        lost_tracker: false
      } }, as: :json
    end

    assert_response :created
  end

  test "should create cat" do
    assert_difference("Cat.count") do
      post api_v1_pets_url, params: { pet: {
        type: "Cat",
        tracker_type: "big",
        owner_id: 2,
        in_zone: false,
        lost_tracker: true
      } }, as: :json
    end

    assert_response :created
    assert_equal "Cat", JSON.parse(response.body)["type"]
  end

  test "should create dog" do
    assert_difference("Dog.count") do
      post api_v1_pets_url, params: { pet: {
        type: "Dog",
        tracker_type: "medium",
        owner_id: 3,
        in_zone: true,
        lost_tracker: false
      } }, as: :json
    end

    assert_response :created
    assert_equal "Dog", JSON.parse(response.body)["type"]
  end

  test "should not create pet with invalid data" do
    assert_no_difference("Pet.count") do
      post api_v1_pets_url, params: { pet: {
        type: "Cat",
        tracker_type: "invalid",
        owner_id: 1,
        in_zone: true,
        lost_tracker: false
      } }, as: :json
    end

    assert_response :unprocessable_content
  end

  test "should show pet" do
    get api_v1_pet_url(@pet), as: :json
    assert_response :success
  end

  test "should update pet" do
    patch api_v1_pet_url(@pet), params: { pet: { in_zone: false } }, as: :json
    assert_response :success
  end

  test "should destroy pet" do
    assert_difference("Pet.count", -1) do
      delete api_v1_pet_url(@pet), as: :json
    end

    assert_response :no_content
  end

  test "should get outside zone statistics" do
    # Clear database to ensure accurate counts
    Pet.destroy_all

    # Create test data
    create(:cat, :outside_zone, :small_tracker, :with_tracker) # lost_tracker: false
    create(:cat, :outside_zone, :big_tracker, :with_lost_tracker) # lost_tracker: true
    create(:dog, :outside_zone, :medium_tracker)
    create(:pet, :in_zone) # This should not be counted

    get api_v1_pets_statistics_outside_zone_url, as: :json
    assert_response :success

    data = JSON.parse(response.body)

    assert_equal 3, data["total_pets_outside_zone"]
    assert_equal 2, data["by_pet_type"]["Cat"]
    assert_equal 1, data["by_pet_type"]["Dog"]
    assert_equal 1, data["cats_with_lost_tracker"]
    assert_equal 1, data["cats_with_tracker"]
    assert_equal 1, data["dogs_by_size"]["medium"]
  end

  test "should handle invalid pet type" do
    assert_no_difference("Pet.count") do
      post api_v1_pets_url, params: { pet: {
        type: "InvalidPet",
        tracker_type: "small",
        owner_id: 1,
        in_zone: true,
        lost_tracker: false
      } }, as: :json
    end

    assert_response :unprocessable_content
  end

  test "should handle dog with lost tracker" do
    assert_no_difference("Dog.count") do
      post api_v1_pets_url, params: { pet: {
        type: "Dog",
        tracker_type: "small",
        owner_id: 1,
        in_zone: true,
        lost_tracker: true
      } }, as: :json
    end

    assert_response :unprocessable_content
  end
end
