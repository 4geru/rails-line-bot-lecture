# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinebotsController, type: :request do
  describe 'POST /create' do
    subject { post linebots_path, params: params.to_json }

    include_context :dummy_line_bot

    let(:params) do
      {
        "events" => [event],
        "destination" => "Ua7ee41c2xxxxxxxxxxxxxxxxxxxxxxxx"
      }
    end

    let(:event) do
      {
        "type" => "message",
        "replyToken" => "76406a55xxxxxxxxxxxxxxxxxxxxxxxx",
        "source" => {
          "userId" => "Ue66de08d9dxxxxxxxxxaxxxxxxxxxxxx",
          "type" => "user"
        },
        "timestamp" => 1586354205898,
        "mode" => "active",
        "message" => {
          "type" => "text",
          "id" => "11749631743000",
          "text" => "ハロー"
        }
      }
    end



    context 'when message type text' do
      it 'return success' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'check event type' do
        subject
        event_class = controller.send(:events).first
        expect(controller.send(:message, event_class)[:type]).to eq 'text'
      end

      xit 'check event type' do
        subject
        event_class = controller.send(:events).first
        expect(controller.send(:message, event_class).first[:type]).to eq 'text'
        expect(controller.send(:message, event_class).second[:type]).to eq 'text'
      end

      it 'check content' do
        subject
        event_class = controller.send(:events).first
        expect(controller.send(:message, event_class).to_s).to match 'こんにちは！！'
      end
    end
  end
end
