class ProposalsController < ApplicationController

  def index
    srand(reviewer.twitter.hash)
    @proposals = Proposal.all(:include=>[:ratings, :presenter]).sort_by{ rand}
  end

  def show
    @proposal = Proposal.find(params[:id], :include=>:presenter)
    @rating = @proposal.reviewer_proposal(reviewer)
  end

  def rate
    @proposal = Proposal.find(params[:id], :include=>:presenter)
    rating_params = params[:rating]
    @proposal.rate(rating_params[:score], rating_params[:comment], reviewer)
    redirect_to proposals_path(:sort => session[:sort])
  end

  def default_route
    redirect_to proposals_path
  end

end
