class PresenterMailer < ActionMailer::Base
  default from: "admin@scotlandjs.com"
  def email_about_proposal(proposal, subject, body)
    presenter = proposal.presenter
    mail(:to => presenter.email,
         :subject=>substitute(proposal, subject),
         :body=>substitute(proposal, body))
  end

  private
  def substitute(proposal, text)
    text.gsub("NAME", proposal.presenter.familiar_name).
         gsub("PRESENTATION", proposal.title)
  end
end
