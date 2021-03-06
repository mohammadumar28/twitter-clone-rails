class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.create(comment_params)
    @comment.user = current_user
    @comment.opinion_id = opinion_id

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_back(fallback_location: root_path) }
        format.json { render :show, status: :created, location: @comment }
      else
        flash[:alert] = @comment.errors.full_messages.join('. ').to_s
        format.html { redirect_back(fallback_location: root_path) }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def opinion_id
    params[:opinion_id]
  end

  def comment_params
    params.require(:comment).permit(:text, :user_id, :opinion_id)
  end
end
