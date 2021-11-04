class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :user_404

  def index
    if params[:user_id]
      user = current_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show 
    if params[:id]
      user = current_user
      item = user.items.find(params[:id])
      render json: item
    else 
      render json: {error: "Item not found"}, status: :unprocessable_entity
    end
  end

  def create 
    if params[:user_id]
      new_item = Item.create(item_params)
      current_user.items << new_item
      render json: new_item, status: :created
    else 
      user_404
    end
  end

  private

  def item_params
    params.permit(:name, :description, :price)
  end

  def current_user 
    User.find(params[:user_id])
  end

  def user_404
    render json: { error: "User not found"}, status: :not_found
  end
end
