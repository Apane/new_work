class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @users = User.all
    @interesting_people = @users.order("random()").first(5)
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @users = User.all
    @interesting_people = @users.order("random()").first(5)
  end

  def inbox
    @users = User.all
    @interesting_people = @users.order("random()").first(5)
    @messages = current_user.received_messages.order('created_at desc')
  end

  def outbox
    @users = User.all
    @interesting_people = @users.order("random()").first(5)
    @messages = current_user.sent_messages.order('created_at desc')
  end

  def delete_message(message)

  end

  # GET /messages/new
  def new
    @message = current_user.sent_messages.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = current_user.sent_messages.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to profile_path(@message.receiver), notice: 'Message sent.' }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { redirect_to profile_path(@message.receiver), notice: 'Message not sent. Please try again.' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:sender_id, :receiver_id, :body, :parent_id)
    end
end
