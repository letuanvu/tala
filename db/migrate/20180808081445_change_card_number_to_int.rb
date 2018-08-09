class ChangeCardNumberToInt < ActiveRecord::Migration[5.2]
  def change
    change_column :cards, :card_number, :integer
    change_column :card_storages, :card_number, :integer
    change_column :player_cards, :card_number, :integer
  end
end
