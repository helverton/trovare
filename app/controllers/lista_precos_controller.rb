class ListaPrecosController < ApplicationController
  before_action :set_lista_preco, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /lista_precos
  # GET /lista_precos.json
  def index
    @lista_precos = ListaPreco.where(entidade_id: current_user.entidade_id, status: 1)
  end

  # GET /lista_precos/1
  # GET /lista_precos/1.json
  def show
  end

  # GET /lista_precos/new
  def new
    @lista_preco = ListaPreco.new
    @servicos = Servico.where(status: 1)
  end

  # GET /lista_precos/1/edit
  def edit
    @servicos = Servico.where(status: 1)
  end

  # POST /lista_precos
  # POST /lista_precos.json
  def create
    @servicos = Servico.where(status: 1)
    @lista_preco = ListaPreco.new(lista_preco_params)
    @lista_preco.status = 1
    @lista_preco.entidade_id = current_user.entidade_id

    respond_to do |format|
      if @lista_preco.save
        format.html { redirect_to lista_precos_url, notice: 'Lista foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @lista_preco }
      else
        format.html { render :new }
        format.json { render json: @lista_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lista_precos/1
  # PATCH/PUT /lista_precos/1.json
  def update
    respond_to do |format|
      if @lista_preco.update(lista_preco_params)
        format.html { redirect_to lista_precos_url, notice: 'Lista foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @lista_preco }
      else
        format.html { render :edit }
        format.json { render json: @lista_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lista_precos/1
  # DELETE /lista_precos/1.json
  def destroy
    respond_to do |format|
      @r = Reserva.where(lista_preco_id: params[:id], status: 1)
      if(@r.any?)
        format.html { redirect_to lista_precos_url, alert: 'Lista não pode ser excluida!' }
        format.json { head :no_content }
      else
        @lista_preco.status = 0
        @lista_preco.save
        format.html { redirect_to lista_precos_url, notice: 'Lista foi excluida com sucesso.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lista_preco
      @lista_preco = ListaPreco.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lista_preco_params
      params.require(:lista_preco).permit(:preco, :tempo, :servico_id)
    end
end
