# frozen_string_literal: true

module LineBot
  # > # ポストバックイベント
  # > ユーザーが、ポストバックアクションを実行したことを示すイベントオブジェクトです。ポストバックイベントには応答できます。
  # https://developers.line.biz/ja/reference/messaging-api/#postback-event
  class PostbackEvent
    def self.send(data)
      data = URI.decode_www_form(data).to_h

      case data['type']
      when 'none'
        # noneの時は何もしない
      when 'middle_search'
        middle_categories = Category.where(parent_category_id: data['category_id'].to_i)
        LineBot::Messages::MiddleCategoriesMessage.new.send(middle_categories)
      when 'small_search'
        LineBot::Messages::SmallCategoriesMessage.new.send(data['category_id'].to_i)
      when 'recipe_search'
        LineBot::Messages::RecipesMessage.new.send(data['category_id'].to_i)
      else
        LineBot::Messages::UnknownMessage.new.send
      end
    end
  end
end
