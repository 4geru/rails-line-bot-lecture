# frozen_string_literal: true

module LineBot
  module Messages
    # 知らないイベントが発生したとき
    class UnknownMessage
      def send
        [
          {
            type: 'text',
            text: 'すいません。よくわかりません。'
          }
        ]
      end
    end
  end
end
