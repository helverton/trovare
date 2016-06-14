class ReservasController < ApplicationController
  before_action :set_reserva, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /reservas
  # GET /reservas.json
  def index
    @reservas = Reserva.where(entidade_id: current_user.entidade_id)
  end

  def reservas
    respond_to do |format| 
      @reservas = Reserva.select('Reservas.id, Reservas.user_id cliente_id, Reservas.data, Reservas.hora_inicio, 
                                  Reservas.entidade_id, e.nome entidade_nome, Reservas.nota, Reservas.profissional_id, p.nome profissional_nome,
                                  s.id servico_id, s.nome servico_nome')
                  .joins('inner join Lista_Precos lp on Reservas.lista_preco_id = lp.id')
                  .joins('inner join Servicos s on lp.servico_id = s.id')
                  .joins('inner join Profissionals p on Reservas.profissional_id = p.id')
                  .joins('inner join Entidades e on Reservas.entidade_id = e.id')
                  .where(user_id: current_user.id)
      format.json { render json: @reservas }
    end 
  end

  def horarios
    @entidade_id = params[:entidade_id]
    @data = params[:data]
    @dsemana = DateTime.parse(@data).wday
    @servico_id = params[:servico_id]
    @profissional_id = params[:profissional_id]

    @servico = ListaPreco.find_by(servico_id: @servico_id)

    @feriado = Horario.where(data: DateTime.parse(@data))
    @vinculo = ProfissionalServico.joins("inner join lista_precos lp on lp.id = profissional_servicos.lista_preco_id")
                                  .where(entidade_id: @entidade_id, profissional_id: @profissional_id)
                                  .where("servico_id =?", @servico_id)             

    if(!(@servico.nil? || @profissional_id.nil? || @dsemana.nil?))

      @tempo = @servico.tempo
    
        respond_to do |format| 
          sql = "WITH RECURSIVE OCPD AS
                (
                  SELECT HORA_INICIO HI, HORA_FIM HF, DIA_SEMANA DS
                  FROM HORARIOS
                  WHERE DATA IS NULL AND ENTIDADE_ID = "+@entidade_id.to_s+"
                  UNION ALL
                  SELECT (HI + INTERVAL '1 MIN'*"+@tempo.to_s+"), HF, DS
                  FROM OCPD
                  WHERE HI < HF
                )
                SELECT HI as hour
                FROM OCPD
                WHERE DS = '"+@dsemana.to_s+"' AND 
                      HI NOT IN (
                          SELECT R.HORA_INICIO 
                          FROM RESERVAS R
                          INNER JOIN LISTA_PRECOS LP ON R.LISTA_PRECO_ID = LP.ID
                          INNER JOIN SERVICOS S ON LP.SERVICO_ID = S.ID
                          WHERE PROFISSIONAL_ID = "+@profissional_id+" AND
                                R.DATA = '"+@data+"'
                      )"      
          @records = ActiveRecord::Base.connection.execute(sql)

          if(!@vinculo.any?)
            @records = []
          end
          if(@feriado.any?)
            @records = []
          end
          format.json { render json: @records }
        end
    else
      respond_to do |format| 
        format.json { render json: '[]' }
      end
    end
  end

  def disp
    @entidade_id = current_user.entidade_id
    @data = params[:data]
    @dsemana = DateTime.parse(@data).wday
    @lista_preco = ListaPreco.find(params[:lista_preco_id])

    @servico_id = @lista_preco.servico_id
    @profissional_id = params[:profissional_id]

    @servico = ListaPreco.find_by(servico_id: @servico_id)
    @tempo = @servico.tempo

    @vinculo = ProfissionalServico.where(lista_preco_id: @lista_preco.id, entidade_id: @entidade_id, profissional_id: @profissional_id)
    @feriado = Horario.where(data: DateTime.parse(@data))

    respond_to do |format| 
      sql = "WITH RECURSIVE OCPD AS
            (
              SELECT HORA_INICIO HI, HORA_FIM HF, DIA_SEMANA DS
              FROM HORARIOS
              WHERE DATA IS NULL AND ENTIDADE_ID = "+@entidade_id.to_s+"
              UNION ALL
              SELECT (HI + INTERVAL '1 MIN'*"+@tempo.to_s+"), HF, DS
              FROM OCPD
              WHERE HI < HF
            )
            SELECT HI as hour
            FROM OCPD
            WHERE DS = '"+@dsemana.to_s+"' AND
                  HI NOT IN (
                      SELECT R.HORA_INICIO 
                      FROM RESERVAS R
                      INNER JOIN LISTA_PRECOS LP ON R.LISTA_PRECO_ID = LP.ID
                      INNER JOIN SERVICOS S ON LP.SERVICO_ID = S.ID
                      WHERE PROFISSIONAL_ID = "+@profissional_id+" AND
                            R.DATA = '"+@data+"'
                  )"
      @records = ActiveRecord::Base.connection.execute(sql)
      if(!@vinculo.any?)
        @records = []
      end
      if(@feriado.any?)
        @records = []
      end
      format.json { render json: @records }
    end
  end

    # GET /reservas/1
  # GET /reservas/1.json
  def show
  end

  # GET /reservas/new
  def new
    @reserva = Reserva.new

    @profissionais = Profissional.where(entidade_id: current_user.entidade_id, status: 1)
    @lista_precos = ListaPreco.where(entidade_id: current_user.entidade_id, status:1)
    @clientes = User.where(tipo: 4, status: 1)
  end

  # GET /reservas/1/edit
  def edit
    @profissionais = Profissional.where(entidade_id: current_user.entidade_id, status: 1)
    @lista_precos = ListaPreco.where(entidade_id: current_user.entidade_id, status: 1)
    @clientes = User.where(tipo: 4, status: 1)
  end

  # POST /reservas
  # POST /reservas.json
  def create    
    @profissionais = Profissional.where(entidade_id: current_user.entidade_id, status: 1)
    @lista_precos = ListaPreco.where(entidade_id: current_user.entidade_id, status: 1)
    @clientes = User.where(tipo: 4, status: 1)

    @reserva = Reserva.new(reserva_params)
    @reserva.status = 1

    if (current_user.tipo.eql? 4)
      @reserva.user_id = current_user.id
    end

    if ((current_user.tipo.eql? 2) or (current_user.tipo.eql? 3))
      @reserva.entidade_id = current_user.entidade_id
    end

    respond_to do |format|
      if @reserva.save
        format.html { redirect_to reservas_url, notice: 'Reserva cadastrada com sucesso.' }
        format.json { render :show, status: :created, location: @reserva }
      else
        format.html { render :new }
        format.json { render json: '{"msg":"Este já tem cadastro!"}', status: :unprocessable_entity }
      end
    end
  end

  def nova
    @reserva = Reserva.new()
    @reserva.user_id = current_user.id #cliente
    @reserva.entidade_id = params[:entidade_id]
    @reserva.data = params[:data]
    @reserva.hora_inicio = params[:hora_inicio]
    @reserva.profissional_id = params[:profissional_id]
    @reserva.telefone = params[:telefone]
    @reserva.status = 1

    @lp_id = ListaPreco.find_by(entidade_id: params[:entidade_id], servico_id: params[:servico_id])

    @reserva.lista_preco_id = @lp_id.id
    if @reserva.save
      render json: '{"success":"Reserva cadastrada com sucesso."}'
    else
      render json: '{"erro":"Não foi possivel salvar!"}'
    end
  end

  def avaliar
    @reserva = Reserva.find(params[:reserva_id])
    respond_to do |format|
      if (@reserva.user_id.eql? current_user.id)
        @reserva.status = 2
        @reserva.nota = params[:nota]
        @reserva.save

        format.json { render json: '{"success":"Obrigado!"}' }
      else
        format.json { render json: '{"erro":"Esta reserva não é sua!"}' }
      end
    end
  end

  # PATCH/PUT /reservas/1
  # PATCH/PUT /reservas/1.json
  def update
    @profissionais = Profissional.where(entidade_id: current_user.entidade_id, status: 1)
    @lista_precos = ListaPreco.where(entidade_id: current_user.entidade_id)
    @clientes = User.where(tipo: 4, status: 1)

    if (current_user.tipo.eql? 4)
      @reserva.user_id = current_user.id
    end

    if ((current_user.tipo.eql? 2) or (current_user.tipo.eql? 3))
      @reserva.entidade_id = current_user.entidade_id
    end

    respond_to do |format|
      if @reserva.update(reserva_params)
        format.html { redirect_to reservas_url, notice: 'Reserva atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @reserva }
      else
        format.html { render :edit }
        format.json { render json: @reserva.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservas/1
  # DELETE /reservas/1.json
  def destroy
    if(@reserva.status.eql? 1)
      @reserva.destroy
      respond_to do |format|
        format.html { redirect_to reservas_url, notice: 'Reserva excluida com sucesso.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to reservas_url, alert: 'Reserva não pode ser excluida.' }
        format.json { head :no_content }
      end
    end
  end

  def encerrar
    @reserva = Reserva.find(params[:reserva_id])

    if (!@reserva.nil?)
      @reserva.status = 2
      @reserva.save
      respond_to do |format|
        format.html { redirect_to reservas_url, notice: 'Reserva atendida com sucesso.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reserva
      @reserva = Reserva.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reserva_params
      if (current_user.tipo.eql? 4)
        params.require(:reserva).permit(:data, :hora_inicio, :nota, :lista_preco_id, :servico_id, :telefone, :profissional_id, :entidade_id, :user_id)
      else
        params.require(:reserva).permit(:data, :hora_inicio, :status, :lista_preco_id, :telefone, :profissional_id, :user_id)
      end
    end
end
