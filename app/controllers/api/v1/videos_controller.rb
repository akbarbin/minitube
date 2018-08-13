class Api::V1::VideosController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show]
  before_action :set_video, only: [:show, :update, :destroy]
  before_action :set_video_authorization, only: [:update, :destroy]

  # GET /videos
  def index
    @videos = Video.search(search_params).includes(:user)
    render json: { videos: @videos }, :include => {:user => {:only => :name} }, methods: :source_file_url
  end

  # GET /videos/:id
  def show
    render json: @video, :include => { :user => {:only => :name }, comments: {include: { user: {:only => :name} } } }, methods: :source_file_url
  end

  # POST /videos
  def create
    @video = current_user.videos.new(video_params)
    @video.source_file.attach(video_params[:source_file])

    if @video.save
      render json: @video, status: :created, location: api_v1_video_url(@video)
    else
      render json: { message: 'Failed to create a video', errors: @video.errors }, status: :unprocessable_entity
    end
  end

  # PACTH/UPDATE /videos/:id
  def update
    if @video.update(video_params)
      render json: @video
    else
      render json: { message: 'Failed to update a video', errors: @video.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /videos/:id
  def destroy
    if @video.source_file.attached?
      @video.source_file.purge
    end
    @video.destroy
  end

  private

  def set_video
    @video = Video.includes(:user, comments: :user).find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: 'Record not found', errors: e.message }, status: :not_found
  end

  def set_video_authorization
    render json: { message: 'Unauthorized', errors: 'Unauthorized' }, status: :unauthorized if current_user.id != @video.user_id
  end

  def video_params
    params.require(:video).permit(:title, :source_file, tags: [])
  end

  def search_params
    params.permit(:keyword, :title, tags: [])
  end
end
