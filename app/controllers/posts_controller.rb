class PostsController < ApplicationController
  before_action :require_user, only: [:index, :new, :edit, :create, :update, :destroy, :delete_image_attachment]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # before_action :set_host_for_local_storage

  # GET /home
  def home
    @home = true
    @posts = Post.order_descending
    @carousel = Post.order_descending.first(3)
    @q = Post.order_descending.ransack(params[:q])
    @posts = @q.result(distinct: true)
    @render_category = true
  end

  # GET /search
  def search
    @search = true
    @render_category = true
    index
    render :index
  end

  # GET /posts
  # GET /posts.json
  def index
    @index = true
    @q = Post.order_descending.ransack(params[:q])
    @posts = @q.result(distinct: true)
    @render_category = true
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @render_category = true
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to new_post_post_attribute_path(post_id: @post.id), flash: { success: 'Post was successfully created.' } }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to rmpost_path(@post), flash: { success: 'Post was successfully updated.' } }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_path, flash: { info: 'Post was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  def delete_image_attachment
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    flash[:info] = 'Image was successfully removed.'
    redirect_back(fallback_location: posts_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :google_map_embed, :image, post_images: [], category_ids: [])
    end

    # For ActiveStorage service_url
    # def set_host_for_local_storage
    #   ActiveStorage::Current.host = request.base_url if Rails.application.config.active_storage.service == :local
    # end
end
