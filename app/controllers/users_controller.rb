class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(params[:user])
        format.html { redirect_to profile_path}
        format.json { respond_with_bip(@user) }
      else
        format.html { render edit}
        # render profile_path
        format.json { respond_with_bip(@user) }
      end
    end
  end

  def show
    @user = User.find(params[:id]) || current_user
    @questions_for_about = @user.questions.for_about.order('id asc')
    @questions_for_personality = @user.questions.for_personality.order('id asc')
  end

  def edit_profile
    @user = current_user
    @questions_for_about = @user.questions.for_about.order('id asc')
    @questions_for_personality = @user.questions.for_personality.order('id asc')
  end

  def refresh_notifcations
    @new_messages = current_user.new_messages.count
  end

  # disconnect from social networks
  def disconnect
    social = params[:social]
    current_user.disconnect(social)
    redirect_to :back
  end

  def visitors
    @visitors = current_user.recent_visitors.order('visited_at desc')
  end

  def toggle_hidden
    @hidden_user_id = params[:hidden_user_id] # sent to js.erb
    if params[:action_type] == 'hide'
      current_user.hidden_users.find_or_create_by(hidden_user_id: @hidden_user_id)
    elsif params[:action_type] == 'unhide'
      current_user.hidden_users.where('hidden_user_id = ?', @hidden_user_id).first.destroy
    end
  end

  def toggle_blocked
    @blocked_user_id = params[:blocked_user_id] # sent to js.erb
    if params[:action_type] == 'unblock'
      current_user.blocked_users.where('blocked_user_id = ?', @blocked_user_id).first.destroy
    elsif params[:action_type] == 'block'
      current_user.blocked_users.find_or_create_by(blocked_user_id: @blocked_user_id)
    end
  end

  def account_registration
    @hidden_users = User.where(id: current_user.hidden_users.pluck(:hidden_user_id))
    @blocked_users = User.where(id: current_user.blocked_users.pluck(:blocked_user_id))
  end

 private
    # Using a private method to encapsulate the permissible parameters
    # is just a good pattern since you'll be able to reuse the same
    # permit list between create and update. Also, you can specialize
    # this method with per-user checking of permissible attributes.
end
