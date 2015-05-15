class CreateRunners < ActiveRecord::Migration
  def change
    create_table :runners do |t|
      t.string :full_name
      t.string :email
      t.integer :age
      t.string :password_digest
      t.string :country
      t.string :registration_id
      t.string :notification_key

      t.timestamps
    end
  end
end
