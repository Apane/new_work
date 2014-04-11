class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @notifications = current_user.notifications.order('id desc')
    @notifications.where(is_opened: false).update_all(is_opened: true)
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read
    if @notification.noteable_type == 'User'
      redirect_to profile_path(@notification.noter)
    elsif @notification.noteable_type == 'Comment'
      redirect_to @notification.noteable.commentable
    else
      redirect_to @notification.noteable
    end
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read
  end

  def delete_notifications
    notifications_ids = params[:notifications].map{|a| a[1]}
    notifications = current_user.notifications.where(id: notifications_ids)
    notifications.delete_all
    redirect_to :back
  end
end
