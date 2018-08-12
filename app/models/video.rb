class Video < ApplicationRecord
  has_one_attached :source_file

  # model associations
  has_many :comments, dependent: :destroy
  belongs_to :user

  # validations
  validates :title, presence: true,
                    length: { minimum:5 }

  # Searching video by title and tags
  def self.search(params)
    conditions = []
    params.each do |key, value|
      if value.present?
        case key.to_s
        when "title"
          conditions << "videos.title ILIKE '%#{value}%'"
        when "tags"
          conditions << "videos.tags @> ARRAY['#{value}']::varchar[]"
        else
          conditions << "videos.#{key} = '#{value}'"
        end
      end
    end

    where(conditions.join(" AND "))
  end
end
