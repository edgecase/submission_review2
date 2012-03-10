require 'test_helper'

class MailToSpeakerTest < ActionMailer::TestCase
  
  def setup 
    @presenter = User.generate(:email=>"bob@bob.com")
    @proposal = Proposal.generate{|prop| prop.presenters << @presenter}
  end
  
  context "basic mailing" do
    setup do 
       @mail = MailToSpeaker.deliver_mail(@proposal,@presenter, :subject=>"Hi there", :body=>"This is the body")
     end
     
     should "send mail" do
       assert_equal "Hi there", @mail.subject
       assert_match /This is the body/, @mail.body
       assert_match /Graeme/, @mail.body
       assert_equal ["bob@bob.com"], @mail.to
       assert_equal ["conference@scottishrubyconference.com"], @mail.from
    end
  end
  
  context "FIRST, LAST, and TITLE" do
    setup do
      @presenter.update_attributes(:first_name=>"Woland", :last_name=>"Lucifer")
      @proposal.update_attributes(:title=>"How to win fiends and infuriate people")
    end
    should "substitute in subject" do
      mail = MailToSpeaker.deliver_mail(@proposal,@presenter, :subject=>"FIRST LAST - TITLE", :body=>"This is the body")
      assert_equal "Woland Lucifer - How to win fiends and infuriate people", mail.subject
    end
    should "substitute in body" do
      mail = MailToSpeaker.deliver_mail(@proposal,@presenter, :subject=>"ho", :body=>"FIRST LAST - TITLE")
      assert_match /Woland Lucifer - How to win fiends and infuriate people/, mail.body
    end
  end

end
