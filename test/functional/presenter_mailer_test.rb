require 'test_helper'

class PresenterMailerTest < ActionMailer::TestCase

  def setup
    @presenter = Factory(:presenter, :email=>'bob@example.com', :familiar_name=>'Bobby')
    @proposal = Factory(:proposal, :presenter=>@presenter, :title=>"Fly Fishing")
  end

  test "sent to presenter" do
    email = PresenterMailer.email_about_proposal(@proposal, "", "")
    assert_equal ["bob@example.com"], email.to
  end

  test "contains body and subject" do
    email = PresenterMailer.email_about_proposal(@proposal, "About something", "Lorem is an ipsum.")

    assert_equal "About something", email.subject
    assert_match "Lorem is an ipsum", email.encoded

  end

  test "replaces NAME with the presenter's familiar name" do
    email = PresenterMailer.email_about_proposal(@proposal, "About NAME", "Lorem is a NAME.")

    assert_equal "About Bobby", email.subject
    assert_match "Lorem is a Bobby", email.encoded
  end

  test "replaces PRESENTATION with the presentaton title" do

    email = PresenterMailer.email_about_proposal(@proposal, "About PRESENTATION", "Lorem is PRESENTATION.")

    assert_equal "About Fly Fishing", email.subject
    assert_match "Lorem is Fly Fishing", email.encoded
  end
end
