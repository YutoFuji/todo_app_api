class Todo < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  validates :title, :content, :status, presence: true
  validates :is_published, inclusion: { in: [true, false] }

  scope :published, -> { where(is_published: true) }
  scope :unpublished, -> { where(is_published: false) }
end
