require 'test_helper'

class ToolsCardsControllerTest < ActionController::TestCase
  setup do
    @tools_card = tools_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tools_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tools_card" do
    assert_difference('ToolsCard.count') do
      post :create, tools_card: { employee_id_id: @tools_card.employee_id_id }
    end

    assert_redirected_to tools_card_path(assigns(:tools_card))
  end

  test "should show tools_card" do
    get :show, id: @tools_card
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tools_card
    assert_response :success
  end

  test "should update tools_card" do
    patch :update, id: @tools_card, tools_card: { employee_id_id: @tools_card.employee_id_id }
    assert_redirected_to tools_card_path(assigns(:tools_card))
  end

  test "should destroy tools_card" do
    assert_difference('ToolsCard.count', -1) do
      delete :destroy, id: @tools_card
    end

    assert_redirected_to tools_cards_path
  end
end
