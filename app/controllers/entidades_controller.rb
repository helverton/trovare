class EntidadesController < ApplicationController
  before_action :set_entidade, only: [:show, :edit, :update, :destroy]
  before_action :authorize
  
  # GET /entidades
  # GET /entidades.json
  def index
    @entidades = Entidade.all
  end

  # GET /entidades/1
  # GET /entidades/1.json
  def show
  end

  def profissionais
    respond_to do |format|  
      @profissionais = ProfissionalServico.select("p.id,(p.nome || ' | media:' || coalesce(cast(avg(r.nota) as int),0)) nome, coalesce(cast(avg(r.nota) as int),0) media")
                       .joins('inner join Lista_Precos lp on Profissional_Servicos.lista_preco_id = lp.id')
                       .joins('inner join profissionals p on Profissional_Servicos.profissional_id = p.id')
                       .joins("left join reservas r on r.profissional_id = p.id")
                       .group("p.id, p.nome")
                       .where('Profissional_Servicos.entidade_id = ? and lp.servico_id = ?', params[:entidade_id], params[:servico_id])
      format.json { render json: @profissionais }
    end
  end

  def cidades 
    respond_to do |format|  
      if (params[:servico] == 'todos')
        @cidades = Entidade.select("distinct entidades.cidade ||'-'|| entidades.estado cidade").where(status: 1)
      else
        @cidades = Entidade
        .select("distinct entidades.cidade ||'-'|| entidades.estado cidade")
        .joins("inner join lista_precos l on l.entidade_id = entidades.id")
        .joins("inner join servicos s on s.id = l.servico_id")
        .where("s.id = ? and entidades.status = ?", params[:servico], 1)
      end

      format.json { render json: @cidades }
    end
  end

  def prestadores 
    respond_to do |format|  
      if (params[:servico] == 'todos' and params[:cidade] == 'todos')
        @prestadores = Entidade.select("entidades.id, (entidades.nome || ' | media:' || coalesce(cast(avg(r.nota) as int),0)) nome, coalesce(cast(avg(r.nota) as int),0) media")
                               .joins("left join reservas r on r.entidade_id = entidades.id")
                               .group("entidades.id, entidades.nome")
                               .where(status: 1)
      elsif (params[:servico] != 'todos' and params[:cidade] == 'todos')
        @prestadores = Entidade
        .select("entidades.id, (entidades.nome || ' | media:' || cast(avg(r.nota) as int)) nome, coalesce(cast(avg(r.nota) as int),0) media")
        .joins("inner join lista_precos l on l.entidade_id = entidades.id")
        .joins("inner join servicos s on s.id = l.servico_id")
        .joins("left join reservas r on r.entidade_id = entidades.id")
        .group("entidades.id, entidades.nome")
        .where("s.id = ? and entidades.status = ?", params[:servico], 1)
      elsif (params[:servico] == 'todos' and params[:cidade] != 'todos')
        @prestadores = Entidade
        .select("distinct entidades.id, (entidades.nome || ' | media:' || cast(avg(r.nota) as int)) nome, coalesce(cast(avg(r.nota) as int),0) media")
        .joins("inner join lista_precos l on l.entidade_id = entidades.id")
        .joins("left join reservas r on r.entidade_id = entidades.id")
        .group("entidades.id, entidades.nome")
        .where("entidades.cidade ||'-'|| entidades.estado = ? and entidades.status = ?", params[:cidade], 1)
      else
        @prestadores = Entidade
        .select("distinct entidades.id, (entidades.nome || ' | media:' || cast(avg(r.nota) as int)) nome, coalesce(cast(avg(r.nota) as int),0) media")
        .joins("inner join lista_precos l on l.entidade_id = entidades.id")
        .joins("inner join servicos s on s.id = l.servico_id")
        .joins("left join reservas r on r.entidade_id = entidades.id")
        .group("entidades.id, entidades.nome")
        .where("s.id = ? and entidades.cidade ||'-'|| entidades.estado = ? and entidades.status = ?", params[:servico], params[:cidade], 1)
      end

        format.json { render json: @prestadores }
    end
  end

  # GET /entidades/new
  def new
    @entidade = Entidade.new
  end

  # GET /entidades/1/edit
  def edit
  end

  # POST /entidades
  # POST /entidades.json
  def create
    @entidade = Entidade.new(entidade_params)
    @entidade.status = 1

    respond_to do |format|
      if @entidade.save
        format.html { redirect_to entidades_url, notice: 'Entidade cadastrada com sucesso.' }
        format.json { render :show, status: :created, location: @entidade }
      else
        format.html { render :new }
        format.json { render json: '{"msg":"Este já tem cadastro!"}', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entidades/1
  # PATCH/PUT /entidades/1.json
  def update
    respond_to do |format|
      if @entidade.update(entidade_params)
        format.html { redirect_to entidades_url, notice: 'Entidade atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @entidade }
      else
        format.html { render :edit }
        format.json { render json: @entidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entidades/1
  # DELETE /entidades/1.json
  def destroy
    respond_to do |format|
      @u = User.where(entidade_id: params[:id], status: 1)
      @r = Reserva.where(entidade_id: params[:id], status: 1)
      if(@u.any? || @r.any?)
        format.html { redirect_to entidades_url, alert: 'Entidade não pode ser excluida!' }
        format.json { head :no_content }
      else
        @entidade.status = 0
        @entidade.save
        format.html { redirect_to entidades_url, notice: 'Entidade excluida com sucesso.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entidade
      @entidade = Entidade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entidade_params
      params.require(:entidade).permit(:nome, :cnpj, :latitude, :longitude, :estado, :cidade, :bairro, :cep, :rua, :numero, :telefone, :contato, :status, :ramo_id)
    end
end
