class AddDescriptionToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :description, :string
  end
end
