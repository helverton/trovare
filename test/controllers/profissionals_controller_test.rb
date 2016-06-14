require 'test_helper'

class ProfissionalsControllerTest < ActionController::TestCase
  setup do
    @profissional = profissionals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profissionals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profissional" do
    assert_difference('Profissional.count') do
      post :create, profissional: { email: @profissional.email, entidade_id: @profissional.entidade_id, nome: @profissional.nome, status: @profissional.status, telefone: @profissional.telefone }
    end

    assert_redirected_to profissional_path(assigns(:profissional))
  end

  test "should show profissional" do
    get :show, id: @profissional
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profissional
    assert_response :success
  end

  test "should update profissional" do
    patch :update, id: @profissional, profissional: { email: @profissional.email, entidade_id: @profissional.entidade_id, nome: @profissional.nome, status: @profissional.status, telefone: @profissional.telefone }
    assert_redirected_to profissional_path(assigns(:profissional))
  end

  test "should destroy profissional" do
    assert_difference('Profissional.count', -1) do
      delete :destroy, id: @profissional
    end

    assert_redirected_to profissionals_path
  end
end
