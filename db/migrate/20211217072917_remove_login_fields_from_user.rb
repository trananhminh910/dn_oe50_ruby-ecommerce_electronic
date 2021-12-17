class RemoveLoginFieldsFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :remember_digest, :string
    remove_column :users, :password_digest, :string
    remove_column :users, :is_active, :boolean
  end
end
