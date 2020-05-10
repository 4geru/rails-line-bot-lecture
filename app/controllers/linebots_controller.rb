# frozen_string_literal: true

class LinebotsController < ApplicationController
  # LINE APIを返すときはつける必要がある
  protect_from_forgery :except => [:create]
  before_action :validate_signature, only: [:create]

  def create
    events.each do |event|
      client.reply_message(event['replyToken'], message(event))
    end
    head :ok
  end

  private

  def body
    @body ||= request.body.read
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end

  def validate_signature
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    head :bad_request unless client.validate_signature(body, signature)
  end

  def events
    @events ||= client.parse_events_from(body)
  end

  def message(event)
    case event
    when Line::Bot::Event::Message
      {
        type: 'text',
        text: event['message']['text']
      }
    end
  end
end
