class Api::V1::CommentsController < ApplicationController
  before_action :set_video
  before_action :set_comment, only: [:show, :update, :delete]
  before_action :set_comment_authorization, only: [:update, :delete]

  # GET /comments
  def index
    @comments = @video.comments
    render json: { data: @comments }
  end

  # GET /comments/:id
  def show
    render json: @comment
  end

  # POST /comments
  def create
    @comment = @video.comments.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      render json: @comment, :include => { :user => {:only => :name } }, status: :created, location: api_v1_video_comment_url(@video, @comment)
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  # PACTH/UPDATE /comments/:id
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /comments/:id
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
  end

  def set_comment
    @comment = Comment.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
  end

  def set_comment_authorization
    return render json: { message: 'Unauthorized' }, status: :unauthorized if current_user.id != @comment.user_id
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
