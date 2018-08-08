class Video < ApplicationRecord
  # model associations
  has_many :comments, dependent: :destroy

  # validations
  validates :title, presence: true,
                    length: { minimum:5 }
  validates :source, presence: true
end
