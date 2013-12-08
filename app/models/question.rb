# -*- coding: utf-8 -*-
class Question < ActiveRecord::Base
  attr_accessible :question, :answer, :for_about, :for_personality
  belongs_to :user
  scope :for_about, -> { where(for_about: true) }
  scope :for_personality, -> { where(for_personality: true) }

  QUESTIONS_FOR_ABOUT = [
    "My self-summary", "What I’m doing with my life", "I’m really good at",
    "The first things people usually notice about me", "Favorite books, movies, shows, music, and food",
    "The six things I could never do without", "I spend a lot of time thinking about",
    "On a typical Friday night I am"
  ]

  QUESTIONS_FOR_PERSONALITY = [
    "My top 5 sports", "My top 5 movies", "My top 5 things to do", "My top 5 foods", "My top 5 websites",
  ]
end
