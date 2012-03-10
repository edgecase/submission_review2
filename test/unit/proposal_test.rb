require 'test_helper'

class ProposalsTest < ActiveSupport::TestCase


  should "rating an unrated proposal" do
    proposal = Proposal.generate
    reviewer = Reviewer.generate
    proposal.rate(4, "pretty good", reviewer)

    assert_equal 1, proposal.ratings.count
    assert_equal reviewer, proposal.ratings.first.reviewer
    assert_equal 4, proposal.ratings.first.score
    assert_equal "pretty good", proposal.ratings.first.comment
  end

  should "rating a proposal already rated by reviewer, updates rating without adding new one" do
    proposal = Proposal.generate
    reviewer = Reviewer.generate
    proposal.rate(4, "pretty good", reviewer)
    proposal.rate(3, "ok", reviewer)

    assert_equal 1, proposal.ratings.count
    assert_equal reviewer, proposal.ratings.first.reviewer
    assert_equal 3, proposal.ratings.first.score
    assert_equal "ok", proposal.ratings.first.comment
  end

  should "reviewer proposal shows only rating for user" do
    proposal = Proposal.generate
    reviewer1 = Reviewer.generate
    reviewer2 = Reviewer.generate
    proposal.rate(4, "super", reviewer1)
    proposal.rate(3, "ok",reviewer2)

    assert_equal 2, proposal.reload.ratings.count
    assert_equal 4, proposal.reviewer_proposal(reviewer1).score
  end

  context "state" do

    setup do
      @proposal = Proposal.generate
    end

    context "initial" do
      should "be submitted" do
        assert_equal 'submitted', @proposal.state
        assert !@proposal.accepted?
        assert !@proposal.confirmed?
      end
    end

    context "transitions" do
      should "go from submitted, to accepted, to confirmed" do
        @proposal.accept
        assert_equal 'accepted', @proposal.state

        @proposal.confirm
        assert_equal 'confirmed', @proposal.state
      end

      should "go from submitted, to reserve, to accepted" do
        @proposal.reserve
        assert_equal 'reserved', @proposal.state
        @proposal.accept
        assert_equal 'accepted', @proposal.state

      end

      should "go from accepted to declined" do
        @proposal.accept
        @proposal.decline
        assert_equal 'declined', @proposal.state
      end

      should "go from confirmed to declined" do
        @proposal.accept
        @proposal.confirm
        @proposal.decline
        assert_equal 'declined', @proposal.state
      end

      should "be able to recover from being declined" do
        @proposal.accept
        @proposal.decline
        @proposal.accept
        assert_equal 'accepted', @proposal.state
      end

    end

    context "named scopes" do
      setup do
        @accepted = (1..3).map{Proposal.generate(:state=>'accepted')}
        @confirmed = (1..3).map{Proposal.generate(:state=>'confirmed')}
      end

      should "return for example only 'accepted' from accepted" do
        assert_equal @accepted, Proposal.accepted
      end

      should "return for example only 'confirmed' from confirmed" do
        assert_equal @confirmed, Proposal.confirmed
      end

    end

  end

  context "delegate votes" do
    setup do
      @proposal = Proposal.generate
      @proposal.proposal_votes.create(:value=>0)
      @proposal.proposal_votes.create(:value=>0)
      @proposal.proposal_votes.create(:value=>0)
      @proposal.proposal_votes.create(:value=>1)
      @proposal.proposal_votes.create(:value=>2)
      @proposal.proposal_votes.create(:value=>2)
    end

    should "punters_for  is count of all votes of value 2" do
      assert_equal 2, @proposal.punters_for
    end
    should "punters_against  is count of all votes of value 0" do
      assert_equal 3, @proposal.punters_against
    end
    should "punters_meh  is count of all votes of value 1" do
      assert_equal 1, @proposal.punters_meh
    end
    should "punters_score  is count of for - against" do
      assert_equal -1, @proposal.punters_score
    end
  end

end
