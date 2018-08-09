class CreateCardStorages < ActiveRecord::Migration[5.2]
  def change
    create_table :card_storages do |t|
      t.string :card_type, index: true
      t.string :card_number, index: true
      t.timestamps
    end
  end
end
