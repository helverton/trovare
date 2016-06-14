class SessionsController < ApplicationController

  def create
    user = User.find_by_email(params[:email])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password]) && user.status == 1
      # Save the user id inside the browser cookie. This is how we keep the user 
      # logged in when they navigate around our website.
      session[:user_id] = user.id

      respond_to do |format|
        if (current_user)
          if (current_user.tipo.eql? 1)
            format.html { redirect_to entidades_path, notice: 'Olá '+current_user.nome }
            format.json { render json: '{"success":"Olá '+current_user.nome+'"}' }
          else
            format.html { redirect_to reservas_path, notice: 'Olá '+current_user.nome }
            format.json { render json: '{"success":"Olá '+current_user.nome+'"}' }
          end
        end
      end
    else
      respond_to do |format|
        if(user && user.authenticate(params[:password]))
          if(user.status == 0)
            format.html { redirect_to '/login', alert: 'Usuário desativado contate a trovare!'}
            format.json { render json: '{"erro":"Usuário desativado contate a trovare ou qualquer prestador!"}' }
          end
        else
          format.html { redirect_to '/login', notice: 'Informações inválidas!'}
          format.json { render json: '{"erro":"Informações inválidas!"}' }
        end
      end
    end
  end

  def destroy
    session[:user_id] = nil

    respond_to do |format|
      if (!current_user)
        format.html { redirect_to '/login', notice: 'Obrigado por sua visita.' }
        format.json { render json: '{"success":"Obrigado por sua visita."}' }
      end
    end
  end
end