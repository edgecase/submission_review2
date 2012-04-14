class Admin::ProposalsController < Admin::AdminController
  class StateFilter
    STATES = Proposal.aasm_states.map(&:name)
    STATES.each do |state| 
      attr_accessor state
    end
    def initialize(args)
      self.confirmed = true
      initialize_from_args(args) if args
    end


    def condition
      states = STATES.find_all {|state| self.send(state)}.map{|state| "'#{state}'"} * ","
      return "1=2" if states.blank?
      "state in (#{states})"
    end
    private

    def initialize_from_args(args)
      STATES.each do |state| 
        self.send "#{state}=", "true" == args[state] 
      end
    end


  end

  def index
    @state_filter = StateFilter.new(params[:state_filter])
    @proposals = Proposal.all(:include=>:presenter, :conditions=>@state_filter.condition).sort_by(&:average_score).reverse
  end

  def email_presenters
    params[:proposal_ids].each do |id|
      proposal = Proposal.find(id)
      PresenterMailer.email_about_proposal(proposal, params[:subject], params[:body]).deliver
    end
  end


  def update_state
    @proposal = Proposal.find(params[:id], :include=>:presenter)
    @proposal.send(params[:event])
    @proposal.save!
    respond_to do |fmt|
      fmt.js
    end
  end


  def delegate_votes
    @proposals = Proposal.confirmed
  end

end
