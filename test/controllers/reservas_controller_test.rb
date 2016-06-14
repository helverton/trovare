require 'test_helper'

class ReservasControllerTest < ActionController::TestCase
  setup do
    @reserva = reservas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reservas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reserva" do
    assert_difference('Reserva.count') do
      post :create, reserva: { data: @reserva.data, entidade_id: @reserva.entidade_id, hora_inicio: @reserva.hora_inicio, nota: @reserva.nota, profissional_id: @reserva.profissional_id, servico_id: @reserva.servico_id, status: @reserva.status, user_id: @reserva.user_id }
    end

    assert_redirected_to reserva_path(assigns(:reserva))
  end

  test "should show reserva" do
    get :show, id: @reserva
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @reserva
    assert_response :success
  end

  test "should update reserva" do
    patch :update, id: @reserva, reserva: { data: @reserva.data, entidade_id: @reserva.entidade_id, hora_inicio: @reserva.hora_inicio, nota: @reserva.nota, profissional_id: @reserva.profissional_id, servico_id: @reserva.servico_id, status: @reserva.status, user_id: @reserva.user_id }
    assert_redirected_to reserva_path(assigns(:reserva))
  end

  test "should destroy reserva" do
    assert_difference('Reserva.count', -1) do
      delete :destroy, id: @reserva
    end

    assert_redirected_to reservas_path
  end
end
