class Api::V1::VideosController < ApplicationController
  before_action :set_video, only: [:show, :update, :delete]

  # GET /videos
  def index
    @videos = current_user.videos.all
    render json: { data: @videos }
  end

  # GET /videos/:id
  def show
    render json: @video
  end

  # POST /videos
  def create
    @video = current_user.videos.new(video_params)
    @video.source_file.attach(video_params[:source_file])

    if @video.save
      render json: @video, status: :created, location: api_v1_video_url(@video)
    else
      render json: @video.errors, status: :unprocessable_entity
    end
  end

  # PACTH/UPDATE /videos/:id
  def update
    if @video.update(video_params)
      render json: @video
    else
      render json: @video.errors, status: :unprocessable_entity
    end
  end

  # DELETE /videos/:id
  def destroy
    @video.destroy
    head :not_content
  end

  private

  def set_video
    @video = Video.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
  end

  def video_params
    params.require(:video).permit(:title, :source_file)
  end
end
