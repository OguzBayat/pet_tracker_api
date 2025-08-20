require "test_helper"

class DogTest < ActiveSupport::TestCase
  def setup
    @dog = build(:dog)
  end

  test "should be valid" do
    assert @dog.valid?
  end

  test "tracker_type should be small, medium, or big" do
    @dog.tracker_type = "invalid"
    assert_not @dog.valid?

    @dog.tracker_type = "small"
    assert @dog.valid?

    @dog.tracker_type = "medium"
    assert @dog.valid?

    @dog.tracker_type = "big"
    assert @dog.valid?
  end

  test "lost_tracker should always be false" do
    @dog.lost_tracker = true
    assert_not @dog.valid?

    @dog.lost_tracker = false
    assert @dog.valid?
  end

  test "by_size scope" do
    small_dog = create(:dog, :small_tracker)
    medium_dog = create(:dog, :medium_tracker)
    big_dog = create(:dog, :big_tracker)

    assert_equal [ small_dog ], Dog.by_size("small")
    assert_equal [ medium_dog ], Dog.by_size("medium")
    assert_equal [ big_dog ], Dog.by_size("big")
  end

  test "dogs_outside_zone_by_size" do
    create(:dog, :outside_zone, :small_tracker)
    create(:dog, :outside_zone, :small_tracker)
    create(:dog, :outside_zone, :medium_tracker)
    create(:dog, :in_zone, :big_tracker)

    result = Dog.dogs_outside_zone_by_size

    assert_equal 2, result["small"]
    assert_equal 1, result["medium"]
    assert_nil result["big"]
  end
end
