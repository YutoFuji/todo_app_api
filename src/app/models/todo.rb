class Todo < ApplicationRecord
  belongs_to :user
  validates :title, :content, :status, :target_completion_date, presence: true
end
