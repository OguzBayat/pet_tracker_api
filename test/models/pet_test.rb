require "test_helper"

class PetTest < ActiveSupport::TestCase
  def setup
    @pet = build(:pet)
  end

  test "should be valid" do
    assert @pet.valid?
  end

  test "tracker_type should be present" do
    @pet.tracker_type = nil
    assert_not @pet.valid?
  end

  test "owner_id should be present" do
    @pet.owner_id = nil
    assert_not @pet.valid?
  end

  test "owner_id should be positive integer" do
    @pet.owner_id = 0
    assert_not @pet.valid?

    @pet.owner_id = -1
    assert_not @pet.valid?

    @pet.owner_id = 1.5
    assert_not @pet.valid?
  end

  test "in_zone should be boolean" do
    @pet.in_zone = nil
    assert_not @pet.valid?
  end

  test "lost_tracker should be boolean" do
    @pet.lost_tracker = nil
    assert_not @pet.valid?
  end

  test "in_zone scope" do
    create(:pet, :in_zone)
    create(:pet, :outside_zone)

    assert_equal 1, Pet.in_zone.count
  end

  test "outside_zone scope" do
    create(:pet, :in_zone)
    create(:pet, :outside_zone)

    assert_equal 1, Pet.outside_zone.count
  end

  test "by_pet_type scope" do
    cat = create(:cat)
    dog = create(:dog)

    assert_equal [ cat ], Pet.by_pet_type("Cat")
    assert_equal [ dog ], Pet.by_pet_type("Dog")
  end

  test "by_tracker_type scope" do
    small_pet = create(:pet, tracker_type: "small")
    big_pet = create(:pet, tracker_type: "big")

    assert_equal [ small_pet ], Pet.by_tracker_type("small")
    assert_equal [ big_pet ], Pet.by_tracker_type("big")
  end

  test "by_owner scope" do
    pet1 = create(:pet, owner_id: 1)
    pet2 = create(:pet, owner_id: 2)

    assert_equal [ pet1 ], Pet.by_owner(1)
    assert_equal [ pet2 ], Pet.by_owner(2)
  end

  test "pets_outside_zone_by_type" do
    create(:cat, :outside_zone, tracker_type: "small")
    create(:cat, :outside_zone, tracker_type: "big")
    create(:dog, :outside_zone, tracker_type: "small")

    result = Pet.pets_outside_zone_by_type

    assert_equal 1, result[[ "Cat", "small" ]]
    assert_equal 1, result[[ "Cat", "big" ]]
    assert_equal 1, result[[ "Dog", "small" ]]
  end

  test "total_pets_outside_zone" do
    create(:pet, :in_zone)
    create(:pet, :outside_zone)
    create(:pet, :outside_zone)

    assert_equal 2, Pet.total_pets_outside_zone
  end

  test "pets_outside_zone_by_pet_type" do
    create(:cat, :outside_zone)
    create(:cat, :outside_zone)
    create(:dog, :outside_zone)

    result = Pet.pets_outside_zone_by_pet_type

    assert_equal 2, result["Cat"]
    assert_equal 1, result["Dog"]
  end

  test "pets_outside_zone_by_tracker_type" do
    create(:pet, :outside_zone, tracker_type: "small")
    create(:pet, :outside_zone, tracker_type: "small")
    create(:pet, :outside_zone, tracker_type: "big")

    result = Pet.pets_outside_zone_by_tracker_type

    assert_equal 2, result["small"]
    assert_equal 1, result["big"]
  end
end
