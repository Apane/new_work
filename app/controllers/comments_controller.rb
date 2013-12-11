class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_commentable

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(params[:comment])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to :back, notice: 'Comment was successfully created.' }
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end
  
  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

end
