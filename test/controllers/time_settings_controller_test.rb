require 'test_helper'

class TimeSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get time_settings_edit_url
    assert_response :success
  end

end
