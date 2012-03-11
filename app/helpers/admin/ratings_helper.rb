module Admin::RatingsHelper

  def td_for(proposal, reviewer)
    content_tag("td", rating_stars(proposal.reviewer_proposal(reviewer)), :id=>proposal_reviewer_id(proposal, reviewer), :class=>'rating')
  end

  def proposal_reviewer_id(proposal, reviewer)
    "proposal_#{proposal.id}_reviewer_#{reviewer.id}"
  end

  def reviewer_comment(proposal, reviewer)
    rating = proposal.reviewer_proposal(reviewer)
    comment = in_paragraphs(proposal.reviewer_proposal(reviewer).comment) if rating
    reviewer_handle = content_tag("p", content_tag("strong", "#{reviewer.twitter}:"))
    tooltip(proposal_reviewer_id(proposal, reviewer), "#{reviewer_handle}#{comment}")
  end

  def proposal_td(proposal)
    proposal_id = "proposal_title_#{proposal.id}"
    content = content_tag("td", link_to(proposal.title, proposal,:id=>proposal_id), :class=>'title')
    tip = tooltip(proposal_id, in_paragraphs(proposal.abstract))
    "#{content}\n#{tip}".html_safe
  end

  def tooltip(id, content)
    javascript_tag(%|$('##{id}').tooltip({bodyHandler:function(){ return'#{content.gsub("'", "\\\\'")}';}, showURL:false})|) 
  end

end
