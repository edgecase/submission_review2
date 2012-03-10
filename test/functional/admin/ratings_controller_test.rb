require 'test_helper'

class Admin::RatingsControllerTest < ActionController::TestCase

  test "non-admin users are not allowed in" do
    logon('rita', :admin=>false)
    get :index
    assert_response :unauthorized
  end

  test "admin users are allowed n" do
    admin_logon
    get :index
    assert_response :success
  end


  test "has a header per reviewer plus one for average and one for title" do
    create_reviewers_and_logon
    get :index
    1.upto(5) do |i|
      assert_select "table#ratings th", :text=>"#{i}rev"
    end

  end


  test "puts reviews in the right place" do
    create_reviewers_and_logon
    proposal = Proposal.generate(:title=>'The Zen of Zen')

    proposal.rate(3, "ok", reviewer2)
    proposal.rate(5, "great", reviewer4)


    get :index
    assert_select "table#ratings tr.proposal td.title", :text=>"The Zen of Zen"


    assert_select "#proposal_#{proposal.id}_reviewer_#{reviewer4.id}"

    assert_select "#proposal_#{proposal.id}_reviewer_#{reviewer4.id} img[alt='score 5']"
    assert_select "#proposal_#{proposal.id}_reviewer_#{reviewer2.id} img[alt='score 3']"
    assert_select "#proposal_#{proposal.id}_reviewer_#{reviewer2.id}"
    assert_select "#proposal_#{proposal.id}_reviewer_#{reviewer3.id} img", :count=>0


  end

  test "print_cards" do
    admin_logon
    get :print_cards
    assert_response :success
    assert assigns(:proposals)
  end


  private
  def create_reviewers_and_logon
    logon('1rev', :admin=>true)
    2.upto(5) do |i|
      Reviewer.generate!(:twitter=>"#{i}rev")
    end
  end

  1.upto(5) do |i|
    define_method "reviewer#{i}" do 
      Reviewer.find_by_twitter("#{i}rev")
    end
  end
  
  def admin_logon
    logon('mavis', :admin=>true)
  end


end
