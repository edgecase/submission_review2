class MailToSpeaker < ActionMailer::Base
  def mail(proposal, speaker, contents)
    @proposal = proposal
    @speaker = speaker
    recipients speaker.email
    from "conference@scottishrubyconference.com"
    subject substitute_content(contents[:subject])
    body "#{substitute_content(contents[:body])}\n---\nAlan, Graeme, Paul\n"

  end

private
  def substitute_content(text)
    text.gsub('FIRST', @speaker.first_name || '').gsub('LAST', @speaker.last_name || '').gsub('TITLE', @proposal.title || '')

  end

end
