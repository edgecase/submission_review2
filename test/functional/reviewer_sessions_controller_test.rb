require 'test_helper'

class ReviewerSessionsControllerTest < ActionController::TestCase

  def setup
    @oauth_client = flexmock('oauth_client')
    flexmock(TwitterOAuth::Client, :new=>@oauth_client)
    @oauth_client.should_receive(:authorize).by_default
    @oauth_client.should_receive(:authorized?).and_return(true).by_default
    @oauth_client.should_receive(:info).and_return('screen_name'=>'rita')
    request_token = flexmock('request_token', :token=>'req_token', :secret=>'req_secret', :authorize_url=>'http://authorize.me')
    @oauth_client.should_receive(:request_token).and_return(request_token).by_default
  end


  test "fail whale page is displayed if Twitter is down on new" do
    @oauth_client.should_receive(:request_token).and_raise(Net::HTTPFatalError.new('', ''))
    get :new
    assert_template 'failwhale'
  end

  test "fail whale page displayed if Twitter goes down during callback" do
    @oauth_client.should_receive(:authorize).and_raise(OAuth::Unauthorized)
    @oauth_client.should_receive(:request_token).and_raise(Net::HTTPFatalError.new('', ''))
    get :callback, :oath_verifier=>'verification key'
    assert_template 'failwhale'
  end

  test "not authorised, if twitter auth fails" do
    @oauth_client.should_receive(:authorize).and_raise(OAuth::Unauthorized)
    get :callback, :oath_verifier=>'verification key'
    assert_response :success
    assert_template 'unauthorised'
    assert !assigns[:reviewer]
    assert_session_and_link_for_oauth

  end

  test "not authorised if reviewer not configured" do
    @oauth_client.should_receive(:info).and_return('screen_name'=>'rita')
    FactoryGirl.create(:reviewer,:twitter=>'marvin')
    get :callback, :oath_verifier=>'verification key'
    assert_response :success
    assert_template 'reviewer_not_configured'
    assert !assigns[:reviewer]
  end

  test "authorised if twitter name is configured" do
    rita = FactoryGirl.create(:reviewer,:twitter=>'rita')

    get :callback, :oath_verifier=>'verification key'
    assert_equal rita, session[:reviewer]
    assert_redirected_to proposals_path
  end

  test "new" do
    get :new
    assert_response :success
    assert_template 'new'
    assert_session_and_link_for_oauth
  end


  test "destroy" do
    logon
    delete :destroy, :id=>session[:reviewer].id
    assert_nil session[:reviewer]
    assert_redirected_to new_reviewer_session_path
  end

  def assert_session_and_link_for_oauth
    assert_equal 'req_token', session[:token]
    assert_equal 'req_secret', session[:secret]
    assert_equal 'http://authorize.me',  assigns['oauth_link']
  end

end
