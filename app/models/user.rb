class User < ApplicationRecord
  validates :first_name, presence: true, on: :create
  validates :last_name, presence: true, on: :create
  validates :role_id, presence: true, on: :create
  validates :password, presence: true, on: :create
  validates :phone, presence: true, on: :create
  has_many :organisasis
  belongs_to :role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
