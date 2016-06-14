class HorariosController < ApplicationController
  before_action :set_horario, only: [:show, :edit, :update, :destroy]

  # GET /horarios
  # GET /horarios.json
  def index
    @horarios = Horario.where(entidade_id: current_user.entidade_id)
  end

  # GET /horarios/1
  # GET /horarios/1.json
  def show
  end

  def week
    @weeks = [
              ['1','Segunda'],
              ['2','Terça'],
              ['3','Quarta'],
              ['4','Quinta'],
              ['5','Sexta'],
              ['6','Sabado'],
              ['0','Domingo']
             ]
    return @weeks
  end

  # GET /horarios/new
  def new
    @horario = Horario.new
    @weeks = week
  end

  # GET /horarios/1/edit
  def edit
    @weeks = week
  end

  # POST /horarios
  # POST /horarios.json
  def create
    @weeks = week
    @horario = Horario.new(horario_params)

    if (current_user.tipo.eql? 2)
      @horario.entidade_id = current_user.entidade_id
    end

    respond_to do |format|
      if @horario.save
        format.html { redirect_to horarios_url, notice: 'Horario salvo com sucesso.' }
        format.json { render :show, status: :created, location: @horario }
      else
        format.html { render :new }
        format.json { render json: '{"msg":"Este já tem cadastro!"}', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /horarios/1
  # PATCH/PUT /horarios/1.json
  def update
    if (current_user.tipo.eql? 2)
      @horario.entidade_id = current_user.entidade_id
    end

    respond_to do |format|
      if @horario.update(horario_params)
        format.html { redirect_to horarios_url, notice: 'Horario atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @horario }
      else
        format.html { render :edit }
        format.json { render json: @horario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /horarios/1
  # DELETE /horarios/1.json
  def destroy
    @horario.destroy
    respond_to do |format|
      format.html { redirect_to horarios_url, notice: 'Horario excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_horario
      @horario = Horario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def horario_params
      if (current_user)
        if (current_user.tipo.eql? 1)
          params.require(:horario).permit(:dia_semana, :hora_inicio, :hora_fim, :data, :entidade_id)
        elsif (current_user.tipo.eql? 2)
          params.require(:horario).permit(:dia_semana, :hora_inicio, :hora_fim, :data)
        else
        end
      end
    end
end
