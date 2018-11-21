class User::ShowSerializer < UserSerializer
  has_many :events
end
