class CreateTreasureHunts < ActiveRecord::Migration[6.0]
  def change
    create_table :treasure_hunts do |t|
      t.string :email
      t.json :current_location
      t.integer :distance

      t.timestamps
    end
  end
end
