class CreateRatings < ActiveRecord::Migration
  def change

    create_table "ratings" do |t|
      t.integer  "reviewer_id"
      t.integer  "proposal_id"
      t.integer  "score"
      t.text     "comment"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ratings", ["proposal_id", "reviewer_id"], :name => "index_ratings_on_proposal_id_and_reviewer_id"
  end
end
