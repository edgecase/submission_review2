class Admin::AcceptedMailingsController <  Admin::AdminController
    before_filter :find_selected_proposals

  def new
  end


  def create

    @proposals.each do |proposal|
      proposal.presenters.each do |presenter|
        MailToSpeaker.deliver_mail(proposal,presenter, params[:email].symbolize_keys)
      end
    end
    flash[:notice]="Mails sent. Gulp."
    redirect_to admin_proposals_path
  end


  private
  def find_selected_proposals
    @proposals = Proposal.find(params[:selected_proposals]) if params[:selected_proposals]
  end
end
