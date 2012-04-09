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
    markdown(text).html_safe
  end

  def markdown(text)
    return "" if text.blank?
    Kramdown::Document.new(text).to_html

  end

  def proposals_class(proposal)
    rating_class = rating(proposal) ? "rated" : "unrated"
    "proposal #{rating_class}"
  end

  def sort_proposals_by(text,param)
    css_class = (params[:sort] == param) ? ' active' : ''
    link_to text, proposals_path(:sort => param), :class => "sortable#{css_class}"
  end


end
