require 'test_helper'

class RamosControllerTest < ActionController::TestCase
  setup do
    @ramo = ramos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ramos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ramo" do
    assert_difference('Ramo.count') do
      post :create, ramo: { descricao: @ramo.descricao, nome: @ramo.nome }
    end

    assert_redirected_to ramo_path(assigns(:ramo))
  end

  test "should show ramo" do
    get :show, id: @ramo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ramo
    assert_response :success
  end

  test "should update ramo" do
    patch :update, id: @ramo, ramo: { descricao: @ramo.descricao, nome: @ramo.nome }
    assert_redirected_to ramo_path(assigns(:ramo))
  end

  test "should destroy ramo" do
    assert_difference('Ramo.count', -1) do
      delete :destroy, id: @ramo
    end

    assert_redirected_to ramos_path
  end
end
