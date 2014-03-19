class QuestionsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  # GET /questions
  # GET /questions.json
  def index
    @questions = current_user.questions.all
    respond_to do |format|
      format.js
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = current_user.questions.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  # def create
  #   @question = current_user.questions.new(question_params)

  #   respond_to do |format|
  #     if @question.save
  #       # format.html { redirect_to :back, notice: 'question was successfully created.' }
  #       # format.json { render action: 'show', status: :created, location: @question }
  #       format.js
  #     else
  #       # format.html { render action: 'new' }
  #       # format.json { render json: @question.errors, status: :unprocessable_entity }
  #       format.js
  #     end
  #   end
  # end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        # format.html { redirect_to :back, notice: 'question was successfully updated.' }
        # format.json { head :no_content }
        format.js
      else
        # format.html { render action: 'edit' }
        # format.json { render json: @question.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = current_user.questions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:answer)
    end
end
