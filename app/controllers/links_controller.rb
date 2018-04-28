class LinksController < ApplicationController
  def index
  end

  def new
  end

  def show
  end

  def edit
  end

  def upvote
    link = Link.find_by(id: params[:id])
    current_user.upvote(link)
    redirect_to root_path
  end
end
