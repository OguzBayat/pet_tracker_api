class PetSerializer < ActiveModel::Serializer
  attributes :id, :type, :tracker_type, :owner_id, :in_zone, :lost_tracker, :created_at, :updated_at

  def type
    object.class.name
  end
end
