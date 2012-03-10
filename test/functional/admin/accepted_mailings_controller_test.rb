require 'test_helper'

class Admin::AcceptedMailingsControllerTest < ActionController::TestCase

  def setup
    logon('mavis', :admin=>true)
  end

  context "security" do
    context "not admin" do
      setup do
        logon('marvin', :admin=>false)
        get :new
      end

      should_respond_with :unauthorized
      should_render_template 'admin/shared/not_admin'
    end

  end

  context "new" do
    setup do
      @proposals = [Proposal.generate, Proposal.generate]
      get :new, :selected_proposals=>@proposals.map{|proposal| proposal.id.to_s}
    end

    should_respond_with :success
    should_render_template :new
    should "find proposals" do
      assert assigns(:proposals)
      assert_same_elements @proposals, assigns(:proposals)
    end
  end

  context "create" do
    setup do
      @proposals = []
      5.times do |i|
        @proposals << Proposal.generate
        @proposals.last.presenters << User.generate
      end
    end

    should "send a mail only for selected proposals" do
      flexmock(MailToSpeaker).should_receive(:deliver_mail).with(@proposals[0], @proposals[0].presenters.first, any).once
      flexmock(MailToSpeaker).should_receive(:deliver_mail).with(@proposals[3], @proposals[3].presenters.first, any).once

      post :create, :email=>{:subject=>"", :body=>""}, :selected_proposals=>[@proposals[0].id, @proposals[3].id]
    end

    should "send a mail for each speaker for each accepted proposal" do
      proposal = @proposals[3]
      proposal.presenters << User.generate
      flexmock(MailToSpeaker).should_receive(:deliver_mail).with(proposal, proposal.presenters[0], any).once
      flexmock(MailToSpeaker).should_receive(:deliver_mail).with(proposal, proposal.presenters[1], any).once
      post :create, :email=>{:subject=>"", :body=>""}, :selected_proposals=>[proposal.id]
    end

    should "send content with the mail" do
      @proposals[0].update_attributes(:state=>'accepted')
      flexmock(MailToSpeaker).should_receive(:deliver_mail).with(any, any, {:subject=>"Congratulations", :body=>"You have won"}).once
      post :create, :email=>{:subject=>"Congratulations", :body=>"You have won"}, :selected_proposals=>[@proposals.first.id]

    end

    context "response " do
      setup do
        post :create, :email=>{:subject=>"Congratulations", :body=>"You have won"}, :selected_proposals=>[@proposals.first.id]
      end

      should_redirect_to("admin_proposals_path"){admin_proposals_path}
      should_set_the_flash_to "Mails sent. Gulp."
    end
  end

end
