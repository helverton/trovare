class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize, except: [:new, :create]

  # GET /users
  # GET /users.json
  def index
    if(current_user.entidade_id.nil?)
      @users = []
      @users.push User.find_by(email: current_user.email)
    else
      @users = User.where(entidade_id: current_user.entidade_id.to_int)
    end

    if(current_user.tipo.eql? 1)
      @users = User.where('tipo = 1 or tipo = 2 or tipo = 4')
    elsif(current_user.tipo.eql? 2)
      @users = User.distinct()
                   .joins('left join reservas r on users.id = r.user_id')
                   .where('(tipo in(2,3) and users.entidade_id=?) or (tipo = 4 and r.entidade_id=?)', current_user.entidade_id, current_user.entidade_id)
    elsif(current_user.tipo.eql? 3)
      @users = User.distinct()
                   .joins('left join reservas r on users.id = r.user_id')
                   .where('tipo = 4 and r.entidade_id=?', current_user.entidade_id)
    else      
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def levels
    @levels = []

    if (current_user)
      if (current_user.tipo.eql? 1)
        @levels = [['1','Master'],['2','Administrador'],['4','Cliente']]
      elsif (current_user.tipo.eql? 2)
        @levels = [['2','Administrador'],['3','Usuário'],['4','Cliente']]
      else
        @levels = [['4','Cliente']]
      end
    else
      @levels = [['4','Cliente']]
    end

    return @levels
  end

  # GET /users/new
  def new
    @user = User.new

    @levels = levels
  end

  # GET /users/1/edit
  def edit
    @levels = levels
  end

  # POST /users
  # POST /users.json
  def create
    @levels = levels
    @user = User.new(user_params)
    
    if (!current_user)
      @user.tipo = 4
    end

    if (current_user)
      if (((current_user.tipo.eql? 2) or (current_user.tipo.eql? 3)) && (@user.tipo.eql? 4))
      elsif (current_user.tipo.eql? 1)
        @user.entidade_id = @user.entidade_id
      else
        @user.entidade_id = current_user.entidade_id
      end
    end
    @user.status = 1

    respond_to do |format|
      if @user.save
        if (params[:modal])
          format.html { redirect_to '/reservas/new', notice: 'Usuário foi criado com sucesso.' }
        else
          format.html { redirect_to @user, notice: 'Usuário foi criado com sucesso.' }
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: '{"msg":"Este já tem cadastro!"}', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      @levels = levels
      @ra = Reserva.where(user_id: params[:id], status: 1)
      @r = Reserva.where(entidade_id: @user.entidade_id, status: 1)

      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: '{"msg":"Este já tem cadastro!"}', status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    respond_to do |format|
      @ra = Reserva.where(user_id: params[:id], status: 1)
      @r = Reserva.where(entidade_id: @user.entidade_id, status: 1)

      if(@ra.any? || (@r.any? && (@user.tipo.eql? 2)) || (@user.nome.eql? 'master'))
        format.html { redirect_to users_url, alert: 'Não pode ser excluido porque tem atividades ativas!' }
        format.json { head :no_content }
      else
        ActiveRecord::Base.connection.execute("update users set status = 0 where id ="+ params[:id])
        format.html { redirect_to users_url, notice: 'Excluido com sucesso.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if (current_user)
        if (current_user.tipo.eql? 1)
          params.require(:user).permit(:nome, :email, :tipo, :status, :entidade_id, :password, :password_confirmation)
        else
          params.require(:user).permit(:nome, :email, :tipo, :status, :password, :password_confirmation)
        end
      else
        params.require(:user).permit(:nome, :email, :tipo, :status, :password, :password_confirmation)
      end
    end
end
