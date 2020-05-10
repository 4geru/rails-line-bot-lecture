# 認証とリプライをスキップしたいのでテスト中はダミーのクラスを定義する

RSpec.shared_context :dummy_line_bot do
  module Line
    module Bot
      class Client
        def reply_message(_token, messages)
          messages
        end

        def validate_signature(_content, _channel_signature)
          true
        end
      end
    end
  end
end
