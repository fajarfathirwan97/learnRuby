class AddOrganizationIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :organisasi_id, :bigInt
  end
end
