class ServicosController < ApplicationController
  before_action :set_servico, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /servicos
  # GET /servicos.json
  def index
    @servicos = Servico.all
  end

  # GET /servicos/1
  # GET /servicos/1.json
  def show
  end

  def servicos 
    respond_to do |format|  
      if (params[:cidade] == 'todos')
        @servicos = Servico
        .select("distinct servicos.id, servicos.nome || ' | media:' || coalesce(cast(avg(r.nota) as int),0) nome, servicos.descricao, coalesce(cast(avg(r.nota) as int),0) media")
        .joins("inner join lista_precos l on l.servico_id = servicos.id")
        .joins("inner join entidades e on e.id = l.entidade_id")
        .joins("left join reservas r on r.lista_preco_id = l.id")
        .group("servicos.id, servicos.nome, servicos.descricao")
        .where(status: 1)
      else
        @servicos = Servico
        .select("distinct servicos.id, servicos.nome || ' | media:' || coalesce(cast(avg(r.nota) as int),0) nome, servicos.descricao, coalesce(cast(avg(r.nota) as int),0) media")
        .joins("inner join lista_precos l on l.servico_id = servicos.id")
        .joins("inner join entidades e on e.id = l.entidade_id")
        .joins("left join reservas r on r.lista_preco_id = l.id")
        .group("servicos.id, servicos.nome, servicos.descricao")
        .where("e.cidade || '-' || e.estado = ? and servicos.status = ?", params[:cidade], 1)
      end

      format.json { render json: @servicos }
    end
  end

  # GET /servicos/new
  def new
    @servico = Servico.new
  end

  # GET /servicos/1/edit
  def edit
  end

  # POST /servicos
  # POST /servicos.json
  def create
    @servico = Servico.new(servico_params)
    @servico.status = 1

    respond_to do |format|
      if @servico.save
        if (params[:modal])
          format.html { redirect_to '/profissional_servicos/new', notice: 'Serviço cadastrado com sucesso.' }
        else
          format.html { redirect_to servicos_url, notice: 'Serviço cadastrado com sucesso.' }
        end
        format.json { render :show, status: :created, location: @servico }
      else
        format.html { render :new }
        format.json { render json: '{"msg":"Este já tem cadastro!"}', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servicos/1
  # PATCH/PUT /servicos/1.json
  def update
    respond_to do |format|
      if @servico.update(servico_params)
        format.html { redirect_to servicos_url, notice: 'Serviço atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @servico }
      else
        format.html { render :edit }
        format.json { render json: @servico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servicos/1
  # DELETE /servicos/1.json
  def destroy
    respond_to do |format|
      @lp = ListaPreco.where(servico_id: params[:id])
      if(@lp.any?)
        format.html { redirect_to servicos_url, alert: 'Serviço não pode ser excluido!' }
        format.json { head :no_content }
      else
        @servico.status = 0
        @servico.save
        format.html { redirect_to servicos_url, notice: 'Serviço excluido com sucesso.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_servico
      @servico = Servico.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def servico_params
      params.require(:servico).permit(:nome, :descricao, :status)
    end
end
