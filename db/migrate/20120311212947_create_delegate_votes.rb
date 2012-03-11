class CreateDelegateVotes < ActiveRecord::Migration
  def change
    create_table "proposal_votes" do |t|
      t.integer  "vote_id"
      t.integer  "proposal_id"
      t.integer  "value"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
