require 'jwt'
class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  # POST /signup
  # return authenticated token after signup
  def create
    user = User.new(user_params)
    if user.save
      payload = { user_id: user.id }

      hmac_secret = 'my$ecretK3ys'

      auth_token = JWT.encode(payload, hmac_secret)

      render json: { message: 'Account created successfully', auth_token: auth_token }
    else
      render json: { message: 'Something went wrong', errors: user.errors }, status: :unprocessable_entity
    end
  end

  def profile
    render json: current_user.to_json(:only => [:id, :email, :name])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
