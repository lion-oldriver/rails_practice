class SearchesController < ApplicationController
  def search
    @model = params["model"]
    @method = params["method"]
    @content = params["content"]
    @records = search_for(@model,@method,@content).page(params[:page]).reverse_order
  end

  def search_for(model,method,content)
    if model == "user"
      if method == 'perfect'
        User.where(name: content)
      elsif method == 'forward_match'
        User.where('name LIKE ?', content+'%')
      elsif method == 'rear_match'
        User.where('name LIKE ?', '%'+content)
      else
        User.where('name LIKE ?', '%'+content+'%')
      end
    elsif model == "blog"
      if method == 'perfect'
        Blog.where(title: content)
      elsif method == 'forward_match'
        Blog.where('title LIKE ?', content+'%')
      elsif method == 'rear_match'
        Blog.where('title LIKE ?', '%'+content)
      else
        Blog.where('title LIKE ?', '%'+content+'%')
      end
    end
  end
end
