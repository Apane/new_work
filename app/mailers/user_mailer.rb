class UserMailer < ActionMailer::Base
  default from: "no-reply@friendiose.com"
  layout 'mail_layout'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_user.subject
  #
  def new_message(message)
    @message = message
    @recipient = message.recipient
    @sender = message.sender
    mail to: @recipient.email, subject: "Friendiose - new message from #{@sender.name}"
  end

  def new_participant(event_participant)
    @event = event_participant.event
    @owner = @event.user
    @participant = event_participant.user
    mail to: @owner.email, subject: "Friendiose - new attendee to #{@event.title} event"
  end

  def new_comment(comment, participant)
    @comment = comment
    @commenter = comment.user
    @commentable = comment.commentable
    @participant = participant
    mail to: participant.email, subject: "Friendiose - new comment to #{@commentable.title} #{@commentable.class.name.downcase}"
  end

  def new_visitor(visit)
    @user = visit.user
    @visitor = visit.visitor

    mail to: @user.email, subject: "Friendiose - #{@visitor.name} visited your profile"
  end

  # def reply_to_request(request)
  #   @request = request
  #   @user = request.user
  #   # users = User.joins(:courses).where('courses.lesson ILIKE ?', request.course.lesson).where('users.id <> ?', request.user_id)
  #   # @users = users.in_range(0..20, units: :km, origin: @user)
  #   mail to: request.email, subject: "Tutorizon - Ενας tutor σου έστειλε την προσφορά του"
  # end
end
