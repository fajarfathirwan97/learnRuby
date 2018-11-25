class Organisasi < ApplicationRecord
  validates :email, presence: true
  validates :website, presence: true
  validates :name, presence: true
  validates :phone, presence: true
end
