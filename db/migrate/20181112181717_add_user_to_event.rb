class AddUserToEvent < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :user, index: true
  end
end
