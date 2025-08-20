require "test_helper"

class CatTest < ActiveSupport::TestCase
  def setup
    @cat = build(:cat)
  end

  test "should be valid" do
    assert @cat.valid?
  end

  test "tracker_type should be small or big" do
    @cat.tracker_type = "medium"
    assert_not @cat.valid?

    @cat.tracker_type = "small"
    assert @cat.valid?

    @cat.tracker_type = "big"
    assert @cat.valid?
  end

  test "lost_tracker should be boolean" do
    @cat.lost_tracker = nil
    assert_not @cat.valid?

    @cat.lost_tracker = true
    assert @cat.valid?

    @cat.lost_tracker = false
    assert @cat.valid?
  end

  test "with_lost_tracker scope" do
    create(:cat, :with_lost_tracker)
    create(:cat, :with_tracker)

    assert_equal 1, Cat.with_lost_tracker.count
  end

  test "with_tracker scope" do
    create(:cat, :with_lost_tracker)
    create(:cat, :with_tracker)

    assert_equal 1, Cat.with_tracker.count
  end

  test "cats_outside_zone_with_lost_tracker" do
    create(:cat, :outside_zone, :with_lost_tracker)
    create(:cat, :outside_zone, :with_tracker)
    create(:cat, :in_zone, :with_lost_tracker)

    assert_equal 1, Cat.cats_outside_zone_with_lost_tracker
  end

  test "cats_outside_zone_with_tracker" do
    create(:cat, :outside_zone, :with_lost_tracker)
    create(:cat, :outside_zone, :with_tracker)
    create(:cat, :in_zone, :with_tracker)

    assert_equal 1, Cat.cats_outside_zone_with_tracker
  end
end
