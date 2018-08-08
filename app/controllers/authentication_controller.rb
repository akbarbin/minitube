class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    @user = User.find_by_email(params[:email])
    if @user.password == params[:password]
      payload = { user_id: @user.id }

      hmac_secret = 'my$ecretK3ys'
      auth_token = JWT.encode(payload, hmac_secret)

      render json: { auth_token: auth_token}
    else
      render json: { message: 'Invalid credentials'}, status: :unauthorized
    end
  end
end
