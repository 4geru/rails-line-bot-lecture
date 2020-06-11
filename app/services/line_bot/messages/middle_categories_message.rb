# frozen_string_literal: true

module LineBot
  module Messages
    # 知らないイベントが発生したとき
    class MiddleCategoriesMessage
      include LineBot::Messages::Concern::Carouselable

      def send(large_category_id)
        @category = Category.find_by(category_id: large_category_id)

        middle_categories = Category.where(parent_category_id: large_category_id)

        bubbles = []
        middle_categories.each_slice(5) do |categories|
          bubbles << bubble(categories)
        end

        carousel("#{@category.name}検索", bubbles)
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
              "size": 'sm',
              "align": "start"
            },
            {
              "type": "button",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "調べる",
                "displayText": category.name,
                "data": "type=small_search&category_id=#{category.category_id}"
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
                "size": "lg",
                "text": @category.name
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
