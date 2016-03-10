class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :first
      t.string :last
      t.string :address
      t.string :zip
      t.string :country
      t.string :email

      t.timestamps null: false
    end
  end
end
