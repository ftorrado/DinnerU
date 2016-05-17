require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup :comments_setup
  teardown :comments_teardown

  test 'should be valid' do
    assert @comment.valid?, @comment.errors.full_messages
  end

  test 'text should be present' do
    @comment.text = '  '
    assert_not @comment.valid?
  end

  test 'text should not be too short' do
    @comment.text = 'a'
    assert_not @comment.valid?
  end

  test 'text should not be too long' do
    @comment.text = 'a' * 61
    assert_not @comment.valid?
  end

  test 'user should be present' do
    @comment.user = nil
    assert_not @comment.valid?
  end
end
