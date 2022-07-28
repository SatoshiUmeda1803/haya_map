class CreateTimeSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :time_settings do |t|
      t.boolean :randomized, null: false, default: false
      t.integer :costom_time, null: false, default: 20
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
