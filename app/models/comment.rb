class Comment < ApplicationRecord
  # model association
  belongs_to :video

  # validation
  validates :body, presence: true
end
