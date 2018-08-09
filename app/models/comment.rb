class Comment < ApplicationRecord
  # model association
  belongs_to :video
  belongs_to :user

  # validation
  validates :body, presence: true
end
