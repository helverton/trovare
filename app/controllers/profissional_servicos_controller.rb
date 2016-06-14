class ProfissionalServicosController < ApplicationController
  before_action :set_profissional_servico, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /profissional_servicos
  # GET /profissional_servicos.json
  def index
    @profissional_servicos = ProfissionalServico.where(entidade_id: current_user.entidade_id)
  end

  # GET /profissional_servicos/1
  # GET /profissional_servicos/1.json
  def show
  end

  def filter
    @profissionais = Profissional.joins("inner join profissional_servicos ps on ps.profissional_id = profissionals.id").where("ps.lista_preco_id" => params[:servico_id] )
    #@profissionais = ProfissionalServico.where(servico_id: params[:servico_id])
  end

  # GET /profissional_servicos/new
  def new
    @profissional_servico = ProfissionalServico.new
    @profissionais = Profissional.where(entidade_id: current_user.entidade_id, status: 1)
    @lista_precos = ListaPreco.where(entidade_id: current_user.entidade_id, status: 1)
  end

  # GET /profissional_servicos/1/edit
  def edit
    @profissionais = Profissional.where(entidade_id: current_user.entidade_id, status: 1)
    @lista_precos = ListaPreco.where(entidade_id: current_user.entidade_id, status: 1)
  end

  # POST /profissional_servicos
  # POST /profissional_servicos.json
  def create
    @profissional_servico = ProfissionalServico.new(profissional_servico_params)
    @profissionais = Profissional.where(entidade_id: current_user.entidade_id, status: 1)
    @lista_precos = ListaPreco.where(entidade_id: current_user.entidade_id, status: 1)

    @profissional_servico.entidade_id = current_user.entidade_id

    respond_to do |format|
      if @profissional_servico.save
        if (params[:modal])
          format.html { redirect_to '/reservas/new', notice: 'Vinculo cadastrado com sucesso.' }
        else
          format.html { redirect_to @profissional_servico, notice: 'Vinculo cadastrado com sucesso.' }
        end
        format.json { render :show, status: :created, location: @profissional_servico }
      else
        format.html { render :new }
        format.json { render json: @profissional_servico.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /profissional_servicos/1
  # PATCH/PUT /profissional_servicos/1.json
  def update
    @profissionais = Profissional.where(entidade_id: current_user.entidade_id, status: 1)
    @lista_precos = ListaPreco.where(entidade_id: current_user.entidade_id, status: 1)
    
    @profissional_servico.entidade_id = current_user.entidade_id

    respond_to do |format|
      if @profissional_servico.update(profissional_servico_params)
        format.html { redirect_to @profissional_servico, notice: 'Vinculo atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @profissional_servico }
      else
        format.html { render :edit }
        format.json { render json: @profissional_servico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profissional_servicos/1
  # DELETE /profissional_servicos/1.json
  def destroy
    respond_to do |format|
      @ps = ProfissionalServico.find(params[:id])
      @r = Reserva.where(lista_preco_id: @ps.lista_preco_id, profissional_id: @ps.profissional_id)
      if(@r.any?)
        format.html { redirect_to profissional_servicos_url, alert: 'Vinculo não pode ser excluido!' }
        format.json { head :no_content }
      else
        @profissional_servico.destroy
        format.html { redirect_to profissional_servicos_url, notice: 'Vinculo excluido com sucesso.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profissional_servico
      @profissional_servico = ProfissionalServico.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profissional_servico_params
      params.require(:profissional_servico).permit(:profissional_id, :lista_preco_id, :entidade_id)
    end
end
