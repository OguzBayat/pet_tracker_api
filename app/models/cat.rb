class Cat < Pet
  # Cat-specific validations
  validates :tracker_type, inclusion: { in: %w[small big] }
  validates :lost_tracker, inclusion: { in: [ true, false ] }

  # Cat-specific scopes
  scope :with_lost_tracker, -> { where(lost_tracker: true) }
  scope :with_tracker, -> { where(lost_tracker: false) }

  # Cat-specific statistics
  def self.cats_outside_zone_with_lost_tracker
    outside_zone.with_lost_tracker.count
  end

  def self.cats_outside_zone_with_tracker
    outside_zone.with_tracker.count
  end
end
