class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.date :start, null: false
      t.date :finish, null: false
      t.string :timezone, null: false
      t.string :name
      t.text :description
      t.string :location
      t.timestamps
    end
  end
end
