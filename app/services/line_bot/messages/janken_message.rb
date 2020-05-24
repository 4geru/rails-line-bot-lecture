# frozen_string_literal: true

module LineBot
  module Messages
    # 知らないイベントが発生したとき
    class JankenMessage
      include LineBot::Messages::Concern::Carouselable

      def send
        carousel('alter_text', [bubble])
      end

      def bubble
        {
          "type": "bubble",
          "hero": {
            "type": "image",
            "url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/01_1_cafe.png",
            "size": "full",
            "aspectRatio": "20:13",
            "aspectMode": "cover",
            "action": {
              "type": "uri",
              "uri": "http://linecorp.com/"
            }
          },
          "body": {
            "type": "box",
            "layout": "vertical",
            "contents": [
              {
                "type": "text",
                "text": "じゃんけんを選んでください"
              }
            ]
          },
          "footer": {
            "type": "box",
            "layout": "vertical",
            "spacing": "sm",
            "contents": [
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "ぐー",
                  "displayText": "ぐー",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "ちょき",
                  "displayText": "ちょき",
                  "data": "type=janken_result&result=choki"
                }
              },
              {
                "type": "button",
                "action": {
                  "type": "postback",
                  "label": "ぱー",
                  "displayText": "ぱー",
                  "data": "type=janken_result&result=pa"
                }
              },
              {
                "type": "spacer",
                "size": "sm"
              }
            ],
            "flex": 0
          }
        }
      end
    end
  end
end
