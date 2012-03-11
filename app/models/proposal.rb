class Proposal < ActiveRecord::Base
  include AASM
  has_many :proposal_votes

  aasm_column :state
  aasm_state :submitted
  aasm_state :accepted
  aasm_state :confirmed
  aasm_state :reserved
  aasm_state :declined

  Proposal.aasm_states.map(&:name).each do |state|
    scope state, :conditions=>{:state=>state.to_s}
  end

  aasm_initial_state :submitted

  aasm_event :accept do
    transitions :to => :accepted, :from=>[:submitted, :reserved, :declined]
  end

  aasm_event :decline do
    transitions :to => :declined, :from=>[:accepted, :confirmed]
  end

  aasm_event :confirm do
    transitions :to => :confirmed, :from=>[:accepted, :declined]
  end

  aasm_event :reserve do
    transitions :to => :reserved, :from=>:submitted
  end

  belongs_to :presenter
  has_many :ratings

  def self.in_order_of_popularity
    self.all(:include=>[:presenter, :ratings]).sort_by(&:average_score).reverse
  end

  def rate(score, comment,  reviewer)
    if (reviewer_proposal(reviewer))
      reviewer_proposal(reviewer).update_attributes!(:score=>score, :comment=>comment)
    else
      ratings.create(:score=>score, :comment=>comment, :reviewer=>reviewer)
    end
  end

  def reviewer_proposal(reviewer)
    ratings.to_a.find{|r| r.reviewer_id == reviewer.id}
  end

  def average_score
    ratings.average(:score) || 0
  end

  %w(against meh for).each_with_index do |method, i|
    define_method "punters_#{method}" do
      proposal_votes.count(:conditions=>{:value=>i})
    end
  end

  def punters_score
    punters_for - punters_against
  end

end
