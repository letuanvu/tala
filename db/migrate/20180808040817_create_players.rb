class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :player_name
      t.integer :player_slot
      t.text :player_cards
      t.timestamps
    end
  end
end
