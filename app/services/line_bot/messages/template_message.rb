# frozen_string_literal: true

module LineBot
  module Messages
    # 知らないイベントが発生したとき
    class TemplateMessage
      include LineBot::Messages::Concern::Carouselable

      def send
        carousel('alter_text', [bubble])
      end

      def bubble
        
      end
    end
  end
end
