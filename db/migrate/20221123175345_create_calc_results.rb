class CreateCalcResults < ActiveRecord::Migration[7.0]
  def change
    create_table :calc_results do |t|
      t.integer :value_one
      t.integer :value_two
      t.text :result

      t.timestamps
    end
  end
end
