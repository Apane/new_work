require 'faraday'

class FayeController < ApplicationController

  def get
    conn = Faraday.new(:url => ENV['FAYE_URL'])
    conn.get params[:query]
  end

  def post
    conn = Faraday.new(:url => ENV['FAYE_URL'])
    conn.post params[:query], params
  end
end
