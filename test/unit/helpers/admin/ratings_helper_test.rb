require 'test_helper'

class Admin::RatingsHelperTest < ActionView::TestCase


  test "tooltip content is quote escaped" do
    content = tooltip(1, "It's great")
    assert_match /'It&rsquo;s great'/, content
  end

  test "tooltip content removes whitespace" do
    content = tooltip(1, "Hello\nma\u2028tey")
    assert_match /Hellomatey/, content
  end
end
