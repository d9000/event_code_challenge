class EventSerializer < ActiveModel::Serializer
  attributes :id, :start, :finish, :timezone, :name, :description, :location, :state, :user_id
end
