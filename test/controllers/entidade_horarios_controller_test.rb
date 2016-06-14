require 'test_helper'

class EntidadeHorariosControllerTest < ActionController::TestCase
  setup do
    @entidade_horario = entidade_horarios(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:entidade_horarios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create entidade_horario" do
    assert_difference('EntidadeHorario.count') do
      post :create, entidade_horario: { entidade_id: @entidade_horario.entidade_id, horario_id: @entidade_horario.horario_id }
    end

    assert_redirected_to entidade_horario_path(assigns(:entidade_horario))
  end

  test "should show entidade_horario" do
    get :show, id: @entidade_horario
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @entidade_horario
    assert_response :success
  end

  test "should update entidade_horario" do
    patch :update, id: @entidade_horario, entidade_horario: { entidade_id: @entidade_horario.entidade_id, horario_id: @entidade_horario.horario_id }
    assert_redirected_to entidade_horario_path(assigns(:entidade_horario))
  end

  test "should destroy entidade_horario" do
    assert_difference('EntidadeHorario.count', -1) do
      delete :destroy, id: @entidade_horario
    end

    assert_redirected_to entidade_horarios_path
  end
end
