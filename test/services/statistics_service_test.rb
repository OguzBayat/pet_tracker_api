require "test_helper"

class StatisticsServiceTest < ActiveSupport::TestCase
  def setup
    # Clear cache before each test
    Rails.cache.clear
  end

  test "should return cached statistics" do
    # Create test data
    create(:cat, :outside_zone, :small_tracker)
    create(:dog, :outside_zone, :medium_tracker)

    # First call should calculate and cache
    stats1 = StatisticsService.get_pets_outside_zone_stats

    # Second call should return cached data
    stats2 = StatisticsService.get_pets_outside_zone_stats

    assert_equal stats1, stats2
    assert_equal 2, stats1["total_pets_outside_zone"]
  end

  test "should invalidate cache" do
    # Create initial data
    create(:cat, :outside_zone)

    # Get initial stats
    initial_stats = StatisticsService.get_pets_outside_zone_stats
    assert_equal 1, initial_stats["total_pets_outside_zone"]

    # Invalidate cache
    StatisticsService.invalidate_cache

    # Add new pet
    create(:dog, :outside_zone)

    # Get new stats (should recalculate)
    new_stats = StatisticsService.get_pets_outside_zone_stats
    assert_equal 2, new_stats["total_pets_outside_zone"]
  end

  test "should refresh cache" do
    # Create initial data
    create(:cat, :outside_zone)

    # Get initial stats
    initial_stats = StatisticsService.get_pets_outside_zone_stats
    assert_equal 1, initial_stats["total_pets_outside_zone"]

    # Add new pet
    create(:dog, :outside_zone)

    # Refresh cache
    refreshed_stats = StatisticsService.refresh_cache
    assert_equal 2, refreshed_stats["total_pets_outside_zone"]
  end

  test "should include all required statistics" do
    # Create diverse test data
    create(:cat, :outside_zone, :small_tracker, :with_tracker)
    create(:cat, :outside_zone, :big_tracker, :with_lost_tracker)
    create(:dog, :outside_zone, :medium_tracker)

    stats = StatisticsService.get_pets_outside_zone_stats

    # Check all required keys exist
    required_keys = [
      "total_pets_outside_zone",
      "by_pet_type",
      "by_tracker_type",
      "by_pet_and_tracker_type",
      "cats_with_lost_tracker",
      "cats_with_tracker",
      "dogs_by_size"
    ]

    required_keys.each do |key|
      assert stats.key?(key), "Missing key: #{key}"
    end

    # Check specific values
    assert_equal 3, stats["total_pets_outside_zone"]
    assert_equal 2, stats["by_pet_type"]["Cat"]
    assert_equal 1, stats["by_pet_type"]["Dog"]
    assert_equal 1, stats["cats_with_lost_tracker"]
    assert_equal 1, stats["cats_with_tracker"]
  end

  test "should handle empty database" do
    # Clear all pets
    Pet.destroy_all

    stats = StatisticsService.get_pets_outside_zone_stats

    assert_equal 0, stats["total_pets_outside_zone"]
    assert_empty stats["by_pet_type"]
    assert_empty stats["by_tracker_type"]
    assert_empty stats["by_pet_and_tracker_type"]
    assert_equal 0, stats["cats_with_lost_tracker"]
    assert_equal 0, stats["cats_with_tracker"]
    assert_empty stats["dogs_by_size"]
  end

  test "should cache expire after configured time" do
    # Create test data
    create(:cat, :outside_zone)

    # Get initial stats
    initial_stats = StatisticsService.get_pets_outside_zone_stats
    assert_equal 1, initial_stats["total_pets_outside_zone"]

    # Manually expire cache by setting short expiry
    Rails.cache.write(StatisticsService::CACHE_KEY, initial_stats, expires_in: 1.second)

    # Wait for cache to expire
    sleep(2)

    # Add new pet
    create(:dog, :outside_zone)

    # Get stats (should recalculate due to expired cache)
    new_stats = StatisticsService.get_pets_outside_zone_stats
    assert_equal 2, new_stats["total_pets_outside_zone"]
  end
end
