class CreateAutobots < ActiveRecord::Migration
  def change
    create_table :autobots do |t|
      t.float :speed
      t.float :calories
      t.integer :heart_rate
      t.integer :rank

      t.timestamps null: false
    end
  end
end
