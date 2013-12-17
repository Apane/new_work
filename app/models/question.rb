# -*- coding: utf-8 -*-
class Question < ActiveRecord::Base
  attr_accessible :question, :answer, :for_about, :for_personality
  belongs_to :user
  scope :for_about, -> { where(for_about: true) }
  scope :for_personality, -> { where(for_personality: true) }

  QUESTIONS_FOR_ABOUT = [
    "What do I do for fun on my free time?", "What kind of things am I into?", "How do I describe my personality?",
    "What am I doing with my life right now"
  ]

  QUESTIONS_FOR_PERSONALITY = [
    "My top 5 sports", "My top 5 movies", "My top 5 things to do", "My top 5 foods", "My top 5 websites",
  ]
end
