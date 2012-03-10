require 'test_helper'

class Admin::RatingsHelperTest < ActionView::TestCase
 
  
  test "tooltip content is quote escaped" do
    content = tooltip(1, "It's great")
    assert_match /'It\\'s great'/, content
  end
  
end
