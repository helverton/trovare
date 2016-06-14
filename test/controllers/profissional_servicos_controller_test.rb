require 'test_helper'

class ProfissionalServicosControllerTest < ActionController::TestCase
  setup do
    @profissional_servico = profissional_servicos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profissional_servicos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profissional_servico" do
    assert_difference('ProfissionalServico.count') do
      post :create, profissional_servico: { references: @profissional_servico.references, references: @profissional_servico.references }
    end

    assert_redirected_to profissional_servico_path(assigns(:profissional_servico))
  end

  test "should show profissional_servico" do
    get :show, id: @profissional_servico
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profissional_servico
    assert_response :success
  end

  test "should update profissional_servico" do
    patch :update, id: @profissional_servico, profissional_servico: { references: @profissional_servico.references, references: @profissional_servico.references }
    assert_redirected_to profissional_servico_path(assigns(:profissional_servico))
  end

  test "should destroy profissional_servico" do
    assert_difference('ProfissionalServico.count', -1) do
      delete :destroy, id: @profissional_servico
    end

    assert_redirected_to profissional_servicos_path
  end
end
