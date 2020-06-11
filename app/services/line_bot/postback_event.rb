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
      when 'janken_result'
        LineBot::Messages::JankenResultMessage.new.send(data)
      when 'middle_search'
        LineBot::Messages::MiddleCategoriesMessage.new.send(data['category_id'].to_i)
      when 'small_search'
        LineBot::Messages::SmallCategoriesMessage.new.send(data['category_id'].to_i)
      # === ここに追加する ===
      # === ここに追加する ===
      else
        LineBot::Messages::UnknownMessage.new.send
      end
    end
  end
end
