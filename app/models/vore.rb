class Vore < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
