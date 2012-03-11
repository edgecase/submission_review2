require 'test_helper'

class ProposalsHelperTest < ActionView::TestCase

  def setup
    logon
  end

  test "rating is nil if no rating given" do
    assert_nil rating(FactoryGirl.create(:proposal))
  end

  test "rating returns stars for" do
    proposal = Proposal.create
    proposal.rate(3, "", session[:reviewer])
    assert_match /score 3/,rating(proposal)

    proposal.rate(2, "", session[:reviewer])
    assert_match /score 2/, rating(proposal)

  end

  test "shortening does not shorten, but does escape,  if less than 50 characters" do
    assert_equal  "Now is the winter of our&gt;discount tents", short( "Now is the winter of our>discount tents")
  end

  test "shortening truncates to 50 characters and adds ellipsis " do
    assert_equal "Now is the winter of our discount&gt;tents, made g...", 
      short("Now is the winter of our discount>tents, made glorious summer by this son of York")
  end


  test "in_paragraphs puts each line in its own escaped html paragraph" do
    assert_equal "<p>I have met them at close of&gt;day</p><p>Coming with vivid faces</p><p>From counter or desk among grey</p><p>Eighteenth-century houses.</p>",
      in_paragraphs(
        "I have met them at close of>day\nComing with vivid faces\nFrom counter or desk among grey\nEighteenth-century houses.")
  end

  test "in paragraphs returns empty if nil" do
    assert in_paragraphs(nil).blank?
  end

  def session
    @session||={}
  end


end
