class CommentsController < ApplicationController
  before_filter :load_commentable

  def index
    @comments = @commentable.current_user.comments
  end

  def new
    @comment = @commentable.current_user.comments.new
  end

  def create
    @comment = @commentable.current_user.comments.new(params[:comment])
    if @comment.save
      redirect_to @commentable, notice: "Comment created."
    else
      render :new
    end
  end
  
  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

end
