class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :card_type, index: true
      t.string :card_number, index: true
      t.timestamps
    end
  end
end
