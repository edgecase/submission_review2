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


  test "in_paragraphs converts to markdown" do
    assert_equal "<p>I have met them at close of&gt;day</p>\n\n<p>Coming with vivid faces</p>\n\n<p>From counter or desk among grey</p>\n\n<p>Eighteenth-century houses.</p>\n",
      in_paragraphs(
        "I have met them at close of>day\n\nComing with vivid faces\n\nFrom counter or desk among grey\n\nEighteenth-century houses.")
  end

  test "in paragraphs returns empty if nil" do
    assert in_paragraphs(nil).blank?
  end

  def session
    @session||={}
  end


end
