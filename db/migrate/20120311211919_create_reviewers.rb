class CreateReviewers < ActiveRecord::Migration
  def change
    create_table "reviewers" do |t|
      t.string   "twitter"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "admin",      :default => false
    end
  end

end
