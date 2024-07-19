class Todo < ApplicationRecord
  belongs_to :user
  validates :title, :content, :status, :target_completion_date, presence: true
  validates :is_published, inclusion: { in: [true, false] }

  scope :published, -> {where(is_published: true)}
  scope :unpublished, -> {where(is_published: false)}
end
