class UsersController < ApplicationController
   
    wrap_parameters format: []
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid

    def create
        # byebug
        new_user = User.create!(user_params)
        session[:user_id] = new_user.id
        render json: new_user, status: :created
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else 
            render json: {error: "Not authorized"}, status: :unauthorized
        end
    end


    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def render_invalid(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
