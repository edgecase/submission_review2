class ReviewerSessionsController < ApplicationController
  CONSUMER_KEY = 'Jqu7Ft29f0rADtMJwuD4tA'
  CONSUMER_SECRET = 'wLMXr75gQ38x7Yxb6IbNPN4mriOaJAoNzn0M3dhslCI'

  skip_before_filter :authenticate  
  before_filter :oauth_client_and_links

  def new
    setup_request_token
  rescue Net::HTTPFatalError
    render :action=>'failwhale'
  end

  def callback
    begin
      @client = TwitterOAuth::Client.new(:consumer_key => CONSUMER_KEY, :consumer_secret => CONSUMER_SECRET)
      @oauth_verifier = params[:oauth_verifier]
      @access_token = @client.authorize(session['token'], session['secret'],  :oauth_verifier => @oauth_verifier)

      @twitter_name = @client.info['screen_name']
      self.reviewer = Reviewer.find_by_twitter(@twitter_name)
      if reviewer
        redirect_to proposals_path
      else
        render :action => 'reviewer_not_configured'
      end

    rescue OAuth::Unauthorized
      setup_request_token
      render :action => 'unauthorised'
    end
  rescue Net::HTTPFatalError
    render :action=>'failwhale'
  end
  
  def destroy
    self.reviewer = nil
    redirect_to :action=>:new
  end

  private
  
  def setup_request_token
    request_token = @client.request_token(:oauth_callback => oauth_callback_url)
    session['token'] = request_token.token
    session['secret'] = request_token.secret
    @oauth_link = request_token.authorize_url
  end


  def oauth_client_and_links
    @client = TwitterOAuth::Client.new(:consumer_key => CONSUMER_KEY, :consumer_secret => CONSUMER_SECRET)
  end

end
