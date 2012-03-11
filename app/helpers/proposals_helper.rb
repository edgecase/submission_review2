module ProposalsHelper

  include ERB::Util
  def rating(proposal)
    rating =proposal.reviewer_proposal(session[:reviewer])
    rating_stars rating
  end


  def rating_stars(rating)
    image_tag "asterisk_orange#{rating.score}.png", :alt=>"score #{rating.score}" if rating
  end

  def short(text, length=50)
    text = h(text)
    return text if text.size <= length
    "#{text[0..(length-1)]}..."
  end

  def in_paragraphs(text)
    return "" if text.blank?
    text.split(/$/).map{|line| "<p>#{h(line.strip)}</p>"}.join if text
  end

  def sort_proposals_by(text,param)
    css_class = (params[:sort] == param) ? ' active' : ''
    link_to text, proposals_path(:sort => param), :class => "sortable#{css_class}"
  end


end
