class BlogsController < ApplicationController
  def new
    @blog = Blog.new
    @blog_file = @blog.blog_files.build
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.user_id = current_user.id
    if @blog.save
      redirect_to blogs_path
    else
      render "new"
    end
  end

  def index
    if params[:sort] == 'evaluations'
      @blogs = Blog.evaluations.page.per(5)
    elsif params[:sort] == 'favorite'
      @blogs = Blog.last_week.page.per(5)
    else
      @blogs = Blog.all.page(params[:page]).per(5).reverse_order
    end
    @categories = Blog.group(:category).count
    @users = current_user.followings
  end

  def show
    @blog = Blog.find(params[:id])
    @blog_comment = BlogComment.new
    @categories = Blog.group(:category).count
    @user = User.find(@blog.user_id)
    @users = current_user.followings
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    @blog.update(blog_params)
    redirect_to blog_path(@blog.id)
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path
  end


  private
  def blog_params
    params.require(:blog).permit(:image, :title, :body, :evaluation, :category, :tag, blog_files_images: [])
  end

end
