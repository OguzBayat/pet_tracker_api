class Dog < Pet
  # Dog-specific validations
  validates :tracker_type, inclusion: { in: %w[small medium big] }
  validates :lost_tracker, inclusion: { in: [ false ] } # Dogs can't lose trackers

  # Dog-specific scopes
  scope :by_size, ->(size) { where(tracker_type: size) }

  # Dog-specific statistics
  def self.dogs_outside_zone_by_size
    outside_zone.group(:tracker_type).count
  end
end
