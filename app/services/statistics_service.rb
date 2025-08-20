# StatisticsService - In-memory storage for pet count data
# This service stores pet count statistics in Rails cache (in-memory)
# as per task requirements for "received pet count data"
class StatisticsService
  CACHE_KEY = "pets_outside_zone_stats"
  CACHE_EXPIRY = 5.minutes

  def self.get_pets_outside_zone_stats
    Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_EXPIRY) do
      calculate_stats
    end
  end

  def self.invalidate_cache
    Rails.cache.delete(CACHE_KEY)
  end

  def self.refresh_cache
    invalidate_cache
    get_pets_outside_zone_stats
  end

  private

  def self.calculate_stats
    {
      "total_pets_outside_zone" => Pet.outside_zone.count,
      "by_pet_type" => Pet.pets_outside_zone_by_pet_type,
      "by_tracker_type" => Pet.pets_outside_zone_by_tracker_type,
      "by_pet_and_tracker_type" => Pet.pets_outside_zone_by_type,
      "cats_with_lost_tracker" => Cat.cats_outside_zone_with_lost_tracker,
      "cats_with_tracker" => Cat.cats_outside_zone_with_tracker,
      "dogs_by_size" => Dog.dogs_outside_zone_by_size
    }
  end
end
