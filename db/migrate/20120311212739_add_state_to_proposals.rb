class AddStateToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :state, :string, :default=>'submitted'
  end
end
