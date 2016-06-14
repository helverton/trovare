require 'test_helper'

class ListaPrecosControllerTest < ActionController::TestCase
  setup do
    @lista_preco = lista_precos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lista_precos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lista_preco" do
    assert_difference('ListaPreco.count') do
      post :create, lista_preco: { entidade_id: @lista_preco.entidade_id, preco: @lista_preco.preco, servico_id: @lista_preco.servico_id, status: @lista_preco.status, tempo: @lista_preco.tempo }
    end

    assert_redirected_to lista_preco_path(assigns(:lista_preco))
  end

  test "should show lista_preco" do
    get :show, id: @lista_preco
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lista_preco
    assert_response :success
  end

  test "should update lista_preco" do
    patch :update, id: @lista_preco, lista_preco: { entidade_id: @lista_preco.entidade_id, preco: @lista_preco.preco, servico_id: @lista_preco.servico_id, status: @lista_preco.status, tempo: @lista_preco.tempo }
    assert_redirected_to lista_preco_path(assigns(:lista_preco))
  end

  test "should destroy lista_preco" do
    assert_difference('ListaPreco.count', -1) do
      delete :destroy, id: @lista_preco
    end

    assert_redirected_to lista_precos_path
  end
end
