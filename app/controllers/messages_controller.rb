class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_message, only: [:edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    # @messages = Message.all
    @messages = current_user.inbox_messages.order('created_at desc').group_by(&:conversation_id)
  end

  def sent
    @messages = current_user.sent_messages.order('created_at asc').group_by(&:conversation_id)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.order('created_at asc')
    @messages.where(recipient_id: current_user.id).update_all(is_new: false)
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
    unless @message.conversation.present?
      conversation = Conversation.create(author_id: @message.sender_id, companion_id: @message.recipient_id)
      @message.conversation_id = conversation.id
    end

    respond_to do |format|
      if @message.save
        format.html { redirect_to profile_path(@message.recipient), notice: 'Message sent.' }
        format.json { render action: 'show', status: :created, location: @message }
        format.js
      else
        format.html { redirect_to profile_path(@message.recipient), notice: 'Message not sent. Please try again.' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
        format.js
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
      params.require(:message).permit(:conversation_id, :sender_id, :recipient_id, :body)
    end
end
