class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.string :option_name, index: true
      t.string :option_value
      t.timestamps
    end
  end
end
