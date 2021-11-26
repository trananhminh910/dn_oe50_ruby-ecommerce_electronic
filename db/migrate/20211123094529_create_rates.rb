class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.float :rating
      t.string :content
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
