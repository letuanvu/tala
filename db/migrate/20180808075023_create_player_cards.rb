class CreatePlayerCards < ActiveRecord::Migration[5.2]
  def change
    create_table :player_cards do |t|
      t.integer :player_slot, index: true
      t.string :card_type, index: true
      t.string :card_number, index: true
      t.boolean :is_showing, index: true
      t.timestamps
    end
  end
end
