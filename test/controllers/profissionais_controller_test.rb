require 'test_helper'

class ProfissionaisControllerTest < ActionController::TestCase
  setup do
    @profissionai = profissionais(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profissionais)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profissionai" do
    assert_difference('Profissionai.count') do
      post :create, profissionai: { email: @profissionai.email, entidade_id: @profissionai.entidade_id, nome: @profissionai.nome, status: @profissionai.status, telefone: @profissionai.telefone }
    end

    assert_redirected_to profissionai_path(assigns(:profissionai))
  end

  test "should show profissionai" do
    get :show, id: @profissionai
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profissionai
    assert_response :success
  end

  test "should update profissionai" do
    patch :update, id: @profissionai, profissionai: { email: @profissionai.email, entidade_id: @profissionai.entidade_id, nome: @profissionai.nome, status: @profissionai.status, telefone: @profissionai.telefone }
    assert_redirected_to profissionai_path(assigns(:profissionai))
  end

  test "should destroy profissionai" do
    assert_difference('Profissionai.count', -1) do
      delete :destroy, id: @profissionai
    end

    assert_redirected_to profissionais_path
  end
end
