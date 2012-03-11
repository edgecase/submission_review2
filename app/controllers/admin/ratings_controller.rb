class Admin::RatingsController < Admin::AdminController
  def index
    @reviewers = Reviewer.all
    @proposals = Proposal.in_order_of_popularity
  end

  def print_cards
    @proposals = Proposal.in_order_of_popularity
  end

end
