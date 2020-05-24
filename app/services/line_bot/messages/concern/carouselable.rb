# frozen_string_literal: true

module LineBot
  module Messages
    module Concern
      module Carouselable
        extend ActiveSupport::Concern

        private

        def carousel(altText, contents)
          {
            type: "flex",
            altText: altText,
            contents: {
              type: "carousel",
              contents: contents
            }
          }
        end

        def bubble(contents)
          {
            type: "bubble",
            body: {
              type: "box",
              layout: "vertical",
              contents: contents
            }
          }
        end
      end
    end
  end
end
