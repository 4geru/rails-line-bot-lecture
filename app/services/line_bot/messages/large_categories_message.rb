# frozen_string_literal: true

module LineBot
  module Messages
    # 知らないイベントが発生したとき
    class LargeCategoriesMessage
      include LineBot::Messages::Concern::Carouselable

      def send
        bubbles = []

        Category.where(type: 'large').each_slice(5) do |categories|
          bubbles << bubble(categories)
        end

        carousel('大カテゴリ検索', bubbles)
      end

      def category_button(category)
        {
          "type": "box",
          "layout": "horizontal",
          "contents": [
            {
              "type": "text",
              "text": category.name,
              "gravity": "center",
              "align": "start"
            },
            {
              "type": "button",
              "action": {
                "type": "postback",
                "label": "調べる",
                "data": "type=middle_search&category_id=#{category.category_id}"
              }
            }
          ]
        }
      end

      def bubble(categories)
        {
          "type": "bubble",
          "header": {
            "type": "box",
            "layout": "vertical",
            "contents": [
              {
                "type": "text",
                "text": "大カテゴリ"
              }
            ]
          },
          "body": {
            "type": "box",
            "layout": "vertical",
            "contents": categories.map { |category| category_button(category) }
          }
        }
      end
    end
  end
end
