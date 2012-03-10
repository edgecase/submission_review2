require File.expand_path("../../test_helper", __FILE__)

class ProposalsControllerTest < ActionController::TestCase

  def setup
    create_some_proposals
    logon
  end

  test "redirects to the new session controller if not logged in" do
    logoff
    get :index
    assert_redirected_to :controller=>:reviewer_sessions, :action=>:new
  end

  test "index finds all proposals" do
    get :index
    assert_response :success
    assert_template 'index'
    assert_select 'td.title', :text=>'Life of fish'
    assert_select 'td.title', :text=>'Fish of life'
    assert_select 'td.presenters', :text=>'Sam Adams'
    assert_select 'td.presenters', :text=>'Sam Adams, Johan Bach'
  end

  test "shows proposal" do
    @proposal.rate(2, "rubbish", session[:reviewer])
    get :show, :id=>@proposal.id
    assert_select '.title', :text=>'Life of fish'
    assert_equal 2, assigns['rating'].score
  end


  test "rates proposal for current reviewer" do
    put :rate, :id=>@proposal.id, :rating=>{:score=>5, :comment=>'Brill!'}
    @proposal.reload
    assert_equal 1, @proposal.ratings.count
    rating = @proposal.ratings.first
    assert_equal 5, rating.score
    assert_equal "Brill!", rating.comment
    assert_equal session[:reviewer], rating.reviewer
  end

  test "after rating goes back to all proposals" do
    put :rate, :id=>@proposal.id, :rating=>{:score=>5, :comment=>'Brill!'}
    assert_redirected_to proposals_path
  end

  context "on GET to :index" do
    setup do
      get :index
    end

  end

  context "on PUT to :rate" do
    setup do
      session[:sort] = 'rating'
      put :rate, :id=>@proposal.id, :rating=>{:score=>5, :comment=>'Brill!'}
    end
    should_redirect_to("proposals index sorted by user's choice") { proposals_path(:sort => 'rating' )}
  end

  private

  def create_some_proposals
    user1 = User.generate(:first_name=>'Sam', :last_name=>'Adams')
    user2 = User.generate(:first_name=>'Johan', :last_name=>'Bach')
    @proposal = Proposal.generate(:title=>'Life of fish', :abstract=>'Carpe diem', :description=>'No bicycles involved.') do |prop|
      prop.presenters << user1 << user2
    end
    Proposal.generate(:title=>'Fish of life') do |prop|
      prop.presenters << user1
    end
  end

  def logon
    session[:reviewer] = Reviewer.generate(:twitter=>'mavis')
  end

  def logoff
    session.delete :reviewer
  end

end
