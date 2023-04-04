class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone_number
      t.string :password_digest
      t.string :code
      t.boolean :verified

      t.timestamps
    end
  end
end
