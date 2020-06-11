# frozen_string_literal: true

class LinebotsController < ApplicationController
  # LINE APIを返すときはつける必要がある
  protect_from_forgery :except => [:create]
  before_action :validate_signature, only: [:create]

  def create
    client.parse_events_from(body).each do |event|
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
    # ここに書いていく
    case event
    when Line::Bot::Event::Postback
      LineBot::PostbackEvent.send(event['postback']['data'])
    when Line::Bot::Event::Message
      case event['message']['type']
      when 'sticker' # スタンプイベントの時
        # === ここに追加する ===
        {
          "type": "sticker",
          "packageId": '11537',
          "stickerId": '52002740'
        }
        # === ここに追加する ===
      when 'text' # メッセージイベントの時
        # event['message']['text'] = ユーザーが送ってきた
        if event['message']['text'] =~ /カテゴリ/
          LineBot::Messages::LargeCategoriesMessage.new.send
        elsif event['message']['text'] =~ /FlexMessage/
          LineBot::Messages::SampleMessage.new.send
        elsif event['message']['text'] =~ /じゃんけん/
          LineBot::Messages::JankenMessage.new.send
        elsif event['message']['text'] =~ /emoji/
          {
            "type": "text",
            "text": "$ LINE emoji $",
            "emojis": [
              {
                "productId": "5ac1bfd5040ab15980c9b435",
                "emojiId": "001",
                "index": 0
              },
              {
                "productId": "5ac1bfd5040ab15980c9b435",
                "emojiId": "002",
                "index": 13
              }
            ]
          }
        elsif event['message']['text'] =~ /料理/
          LineBot::Messages::LargeCategoriesMessage.new.send
        else
          translatec_text, emoji_list = LineBot::EmojiWord.new.translate_to_emoji(event['message']['text'])
          {
            "type": "text",
            "text": translatec_text,
            "emojis": emoji_list
          }
        end
      end
    end
  end
end
