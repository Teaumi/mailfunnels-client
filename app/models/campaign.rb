class Campaign < RestModel

	has_one :hook
	belongs_to :app
	has_one :email_list
	has_many :jobs
	belongs_to :app
	has_many :campaign_product_leads

	# accepts_nested_attributes_for :hooks
end
