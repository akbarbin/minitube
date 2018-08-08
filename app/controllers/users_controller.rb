require 'jwt'
class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  # POST /signup
  # return authenticated token after signup
  def create
    user = User.new(user_params)
    if user.save
      payload = { user_id: user.id }

      hmac_secret = 'my$ecretK3ys'

      auth_token = JWT.encode(payload, hmac_secret)

      render json: { message: 'Account created successfully', auth_token: auth_token}
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
