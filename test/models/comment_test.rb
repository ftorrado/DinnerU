require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = create(:comment)
  end

  test 'should be valid' do
    assert @comment.valid?, @comment.errors.full_messages
  end

  test 'content should be present' do
    @comment.content = '  '
    assert_not @comment.valid?
  end

  test 'content should not be too short' do
    @comment.content = 'a'
    assert_not @comment.valid?
  end

  test 'content should not be too long' do
    @comment.content = 'a' * 61
    assert_not @comment.valid?
  end
end
