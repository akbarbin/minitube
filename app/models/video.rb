class Video < ApplicationRecord
  has_one_attached :source_file

  # model associations
  has_many :comments, dependent: :destroy
  belongs_to :user

  # validations
  validates :title, presence: true,
                    length: { minimum:5 }
end
