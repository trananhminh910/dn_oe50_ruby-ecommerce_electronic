class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.boolean :gender
      t.string :avatar
      t.integer :role, default: 2, null: false
      t.boolean :is_active
      t.string :password_digest

      t.timestamps
    end
  end
end
