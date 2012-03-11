require 'test_helper'

class Admin::ProposalsControllerTest < ActionController::TestCase

  def setup 
    logon('arnold', :admin=>true)
  end

  context "index" do
    context "without filter" do
      setup do
        get :index
      end

      should respond_with :success
      should render_template 'index'
      should assign_to :proposals

      should "assign state_filter to 'confirmed" do
        state_filter= assigns['state_filter']
        assert state_filter
        assert !state_filter.submitted
        assert state_filter.confirmed
      end
    end

    context "with filter" do
      setup do
        @in_filter = []
        @in_filter << FactoryGirl.create(:proposal, :state=>'submitted') << FactoryGirl.create(:proposal, :state=>'reserved')
        FactoryGirl.create(:proposal, :state=>'confirmed')

        get :index, :state_filter=>{:submitted=>'true', :reserved=>'true'}
      end

      should "assign values on state filter" do
        state_filter= assigns['state_filter']
        assert state_filter
        assert state_filter.submitted
        assert state_filter.reserved
        assert !state_filter.confirmed
      end

      should "return only filtered values" do
        assert_equal @in_filter.sort_by(&:id), assigns['proposals'].sort_by(&:id)
      end

    end

    context "filtering all states out" do
      setup do
        3.times{FactoryGirl.create(:proposal)}

        get :index, :state_filter=>{:reserved=>'false'}
      end

      should "find no proposals" do
        assert_equal [], assigns['proposals']
      end

    end



  end

  context "update state" do
    setup do
      @proposal = FactoryGirl.create(:proposal, :state=>'submitted')
      put :update_state, :id=>@proposal.id, :event=>'accept'
    end

    should "update the proposal state" do
      assert_equal 'accepted', @proposal.reload.state
    end

    should render_template 'proposal'



  end

end
