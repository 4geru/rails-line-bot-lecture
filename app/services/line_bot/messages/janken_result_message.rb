# frozen_string_literal: true

module LineBot
  module Messages
    # 知らないイベントが発生したとき
    class JankenResultMessage
      include LineBot::Messages::Concern::Carouselable

      def send(data)
        janken_hash = { gu: 'ぐー', choki: 'ちょき', pa: 'ぱー' }
        result = janken_hash[data['result'].to_sym]
        computer_result = ['ぐー', 'ちょき', 'ぱー'].sample

        if result == computer_result
          [
            {
              type: 'text',
              text: 'あなたは「' + result + "」を出しました\nLINE Botは「" + computer_result + '」を出しました'
            },
            {
              type: 'text',
              text: 'あいこで'
            },
            LineBot::Messages::JankenMessage.new.send
          ]
        else
          {
            type: 'text',
            text: 'あなたは「' + result + "」を出しました\nLINE Botは「" + computer_result + '」を出しました'
          }
        end
      end
    end
  end
end
