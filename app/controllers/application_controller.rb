class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery prepend: true

  before_action :authorize_request
  attr_reader :current_user

  private
  # attr_reader :headers

  def authorize_request
    require 'jwt'
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end

    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def http_token
    if request.headers['Authorization'].present?
      @http_token = request.headers['Authorization'].split(' ').last
    else
      @http_token = nil
    end
  end

  def auth_token
    body = JWT.decode(http_token, 'my$ecretK3ys')[0]
    HashWithIndifferentAccess.new body
    # rescue from all decode errors
  rescue JWT::DecodeError => e
    # raise custom error to be handled by custom handler
    puts e.message
    # raise render json: { errors: e.message }, status: :unauthorized

  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end
end
