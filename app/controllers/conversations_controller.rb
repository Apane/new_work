class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_conversation, only: [:show, :edit, :update, :report]

  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = Conversation.all
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
  end

  def refresh_messages
    @conversation = Conversation.find(params[:id])
    @message = @conversation.messages.order('id asc').last
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations
  # POST /conversations.json
  def create
    @conversation = Conversation.new(conversation_params)

    respond_to do |format|
      if @conversation.save
        format.html { redirect_to @conversation, notice: 'Conversation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @conversation }
      else
        format.html { render action: 'new' }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conversations/1
  # PATCH/PUT /conversations/1.json
  def update
    respond_to do |format|
      if @conversation.update(conversation_params)
        format.html { redirect_to @conversation, notice: 'Conversation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  def act_on_conversations
    ids = params[:conversations].to_a.map{|c| c[1]}
    conversations =  Conversation.where(id: ids)
    action = params[:act]
    Conversation.act_on_conversations(conversations, action, current_user, params[:users])
    redirect_to :back
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation.messages.map{|m| m.destroy}
    @conversation.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def report
    @conversation.reports.create(user_id: current_user.id)
    redirect_to :back, notice: ' Conversation has been reported! The administration will be notified.'
  end

  def block_user
    companion = User.find(params[:id])
    current_user.block(companion)
    redirect_to :back, notice: "#{companion.username} blocked"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conversation_params
      params.require(:conversation).permit(:author_id, :companion_id)
    end
end
