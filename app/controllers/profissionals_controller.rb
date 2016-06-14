class ProfissionalsController < ApplicationController
  before_action :set_profissional, only: [:show, :edit, :update, :destroy]
  before_action :authorize
  
  # GET /profissionals
  # GET /profissionals.json
  def index
    @profissionals = Profissional.where(entidade_id: current_user.entidade_id, status: 1)
  end

  # GET /profissionals/1
  # GET /profissionals/1.json
  def show
  end

  # GET /profissionals/new
  def new
    @profissional = Profissional.new
  end

  # GET /profissionals/1/edit
  def edit
  end

  # POST /profissionals
  # POST /profissionals.json
  def create
    @profissional = Profissional.new(profissional_params)

    if (current_user.tipo.eql? 2)
      @profissional.entidade_id = current_user.entidade_id
    end
    @profissional.status = 1

    respond_to do |format|
      if @profissional.save
        if (params[:modal])
          format.html { redirect_to '/profissional_servicos/new', notice: 'Profissional cadastrado com sucesso.' }
        else
          format.html { redirect_to @profissional, notice: 'Profissional cadastrado com sucesso.' }
        end
        format.json { render :show, status: :created, location: @profissional }
      else
        format.html { render :new }
        format.json { render json: '{"msg":"Este já tem cadastro!"}', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profissionals/1
  # PATCH/PUT /profissionals/1.json
  def update
    if (current_user.tipo.eql? 2)
      @profissional.entidade_id = current_user.entidade_id
    end

    respond_to do |format|
      if @profissional.update(profissional_params)
        format.html { redirect_to @profissional, notice: 'Profissional atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @profissional }
      else
        format.html { render :edit }
        format.json { render json: @profissional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profissionals/1
  # DELETE /profissionals/1.json
  def destroy
    @r = Reserva.where(profissional_id: params[:id])
    @ps = ProfissionalServico.where(profissional_id: params[:id])
    respond_to do |format|
      if(@r.any? || @ps.any?)
          format.html { redirect_to profissionals_url, alert: 'Profissional não pode ser excluido!' }
          format.json { head :no_content }
      else
        @profissional.destroy
          format.html { redirect_to profissionals_url, notice: 'Profissional excluido com sucesso.' }
          format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profissional
      @profissional = Profissional.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profissional_params
      params.require(:profissional).permit(:nome, :email, :telefone, :status)
    end
end
