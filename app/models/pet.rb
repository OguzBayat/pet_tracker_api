class Pet < ApplicationRecord
  # STI support
  self.inheritance_column = :type

  # Validations
  validates :tracker_type, presence: true
  validates :owner_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :in_zone, inclusion: { in: [ true, false ] }
  validates :lost_tracker, inclusion: { in: [ true, false ] }

  # Scopes
  scope :in_zone, -> { where(in_zone: true) }
  scope :outside_zone, -> { where(in_zone: false) }
  scope :by_pet_type, ->(pet_type) { where(type: pet_type) }
  scope :by_tracker_type, ->(tracker_type) { where(tracker_type: tracker_type) }
  scope :by_owner, ->(owner_id) { where(owner_id: owner_id) }

  # Class methods for statistics
  def self.pets_outside_zone_by_type
    outside_zone.group(:type, :tracker_type).count
  end

  def self.total_pets_outside_zone
    outside_zone.count
  end

  def self.pets_outside_zone_by_pet_type
    outside_zone.group(:type).count
  end

  def self.pets_outside_zone_by_tracker_type
    outside_zone.group(:tracker_type).count
  end

  # Cache invalidation for in-memory statistics
  after_save :invalidate_statistics_cache
  after_destroy :invalidate_statistics_cache

  private

  def invalidate_statistics_cache
    StatisticsService.invalidate_cache
  end
end
