require 'test_helper'

class WombatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @wombat = wombats(:one)
  end

  test "should get index" do
    get wombats_url
    assert_response :success
  end

  test "should get new" do
    get new_wombat_url
    assert_response :success
  end

  test "should create wombat" do
    assert_difference('Wombat.count') do
      post wombats_url, params: { wombat: { body: @wombat.body, published: @wombat.published, title: @wombat.title } }
    end

    assert_redirected_to wombat_url(Wombat.last)
  end

  test "should show wombat" do
    get wombat_url(@wombat)
    assert_response :success
  end

  test "should get edit" do
    get edit_wombat_url(@wombat)
    assert_response :success
  end

  test "should update wombat" do
    patch wombat_url(@wombat), params: { wombat: { body: @wombat.body, published: @wombat.published, title: @wombat.title } }
    assert_redirected_to wombat_url(@wombat)
  end

  test "should destroy wombat" do
    assert_difference('Wombat.count', -1) do
      delete wombat_url(@wombat)
    end

    assert_redirected_to wombats_url
  end
end
