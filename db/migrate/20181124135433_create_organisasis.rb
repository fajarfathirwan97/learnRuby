class CreateOrganisasis < ActiveRecord::Migration[5.2]
  def change
    create_table :organisasis do |t|
      t.belongs_to :user
      t.string :name
      t.string :logo
      t.string :phone
      t.string :email
      t.string :website
      t.timestamps
    end
  end
end
