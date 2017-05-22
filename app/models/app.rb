class App < RestModel

	has_many :email_templates
	has_many :email_lists
	has_many :subscribers
	has_many :funnels
	has_many :triggers
	has_many :captured_hooks

	def myId()
		# TODO: Verify this works / get it working
		# Get Shopify App Name
		# name = ShopifyAPI::Store::name
		name = 'bluehelmet-dev'
		return App.where(name: name).first.id
	end

	# accepts_nested_attributes_for :campaigns
end
