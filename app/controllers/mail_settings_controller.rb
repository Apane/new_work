class MailSettingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_mail_setting, only: [:update]

  # GET /questions/1/edit
  def edit
  end

  def update
    respond_to do |format|
      if @mail_setting.update(setting_param)
        format.html { redirect_to :back, notice: 'Mail setting was successfully updated.' }
        # format.json { head :no_content }
        # format.js
      else
        format.html { render action: 'edit' }
        # format.json { render json: @mail_setting.errors, status: :unprocessable_entity }
        # format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mail_setting
      @mail_setting = current_user.mail_setting
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_param
      params.require(:mail_setting).permit(:user_id, :new_message, :new_reply, :join_event, :comment_on_event, :viewed_profile, :newsletter)
    end
end
