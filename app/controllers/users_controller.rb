class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user
    @users = User.where.not(id: current_user.id)
  else
    @users = User.all
  end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update(params[:user])
        format.html { redirect_to profile_path}
        format.json { respond_with_bip(current_user) }
        format.js
      else
        format.html { render edit}
        format.json { respond_with_bip(current_user) }
        format.js
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

  def edit_age
  end

  def update_age
    current_user.update_attributes(birthday: params[:user][:birthday])
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
    @events = current_user.events
    @activities = current_user.activities
  end

  def update_profile_completness
    respond_to do |format|
      format.js
    end
  end

  def disable_account
    current_user.disable_account
    Devise.sign_out_all_scopes ? sign_out : sign_out(current_user)
    redirect_to root_path, notice: 'Account was disabled. Sign in to enable it again.'
  end

  def post_to_facebook
    current_user.post_to_wall
    open_visitors('Facebook')
  end

  def post_to_twitter
    current_user.post_tweets
    open_visitors('Twitter')
  end

  def open_visitors(provider)
    current_user.open_visitors_at = Time.now
    current_user.save(validation: false)
    redirect_to :back, notice: "Congrats, you've successfully unlocked this premium feature. Your message has been posted to #{provider}. You can now see who viewed your profile for 1 month!"
  end

  def users_interests
    pref = params[:user].to_json
    current_user.preferences = pref
    current_user.save(validation: false)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

 private
    # Using a private method to encapsulate the permissible parameters
    # is just a good pattern since you'll be able to reuse the same
    # permit list between create and update. Also, you can specialize
    # this method with per-user checking of permissible attributes.
end
