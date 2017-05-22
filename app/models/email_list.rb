class EmailList < ApplicationRecord
  validates :name, presence: true

  belongs_to :app, :class_name => 'App', :foreign_key => 'app_id'

  has_many :subscribers
end
