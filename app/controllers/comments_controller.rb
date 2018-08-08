class CommentsController < ApplicationController
  before_action :set_video
  before_action :set_comment, only: [:show, :update, :delete]

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

    if @comment.save
      render json: @comment, status: :created, location: video_comment_url(@video, @comment)
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PACTH/UPDATE /comments/:id
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/:id
  def destroy
    @comment.destroy
    head :not_content
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
  end

  def set_comment
    @comment = @video.comments.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
