class AddPhoneToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone, :string
    add_column :users, :role_id, :bigInt
  end
end
