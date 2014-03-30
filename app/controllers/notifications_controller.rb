class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @notifications = current_user.notifications.order('id desc')
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read
    redirect_to @notification.noteable
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
