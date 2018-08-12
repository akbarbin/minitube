class Api::V1::VideosController < ApplicationController
  before_action :set_video, only: [:show, :update, :delete]
  before_action :set_video_authorization, only: [:update, :delete]

  # GET /videos
  def index
    @videos = Video.search(search_params)
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
      render json: { errors: @video.errors }, status: :unprocessable_entity
    end
  end

  # PACTH/UPDATE /videos/:id
  def update
    if @video.update(video_params)
      render json: @video
    else
      render json: { errors: @video.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /videos/:id
  def destroy
    @video.destroy
    @video.source_file.purge
    head :not_content
  end

  private

  def set_video
    @video = Video.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
  end

  def set_video_authorization
    return render json: { message: 'Unauthorized' }, status: :unauthorized if current_user.id != @video.user_id
  end

  def video_params
    params.require(:video).permit(:title, :source_file, tags: [])
  end

  def search_params
    params.fetch(:search, {}).permit(:title, tags: [])
  end
end
