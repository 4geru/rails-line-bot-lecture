# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinebotsController, type: :request do
  describe 'POST /create' do
    subject { post linebots_path, params: params.to_json }

    include_context :dummy_line_bot

    let(:params) do
      {
        "events" => events,
        "destination" => "Ua7ee41c2xxxxxxxxxxxxxxxxxxxxxxxx"
      }
    end

    let(:events) do
      [
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
            "text" => "初めまして"
          }
        }
      ]
    end

    let(:event_result) do
      {
        type: "text",
        text: "初めまして"
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

      it 'check content' do
        subject
        event_class = controller.send(:events).first
        expect(controller.send(:message, event_class).to_s).to match '初めまして'
      end
    end
  end
end
