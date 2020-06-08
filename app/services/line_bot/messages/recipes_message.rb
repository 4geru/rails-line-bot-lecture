# frozen_string_literal: true

module LineBot
  module Messages
    # 知らないイベントが発生したとき
    class RecipesMessage
      include LineBot::Messages::Concern::Carouselable

      def send(small_category_id)
        @category = Category.find_by(category_id: small_category_id)
        response = RakutenApi::RecipesApi.get(small_category_id)
        
        recipes = JSON.parse(response.body)['result']
        bubbles = recipes.map do |recipe|
          bubble(recipe)
        end

        carousel(@category.name, bubbles)
      end

      def bubble(recipe)
        {
          "type": "bubble",
          "hero": {
            "type": "image",
            "url": recipe['foodImageUrl'],
            "size": "full",
            "aspectRatio": "20:13",
            "aspectMode": "cover",
            "action": {
              "type": "uri",
              "uri": recipe['recipeUrl']
            }
          },
          "body": {
            "type": "box",
            "layout": "vertical",
            "contents": [
              {
                "type": "text",
                "text": recipe['recipeTitle'],
                "weight": "bold",
                "size": "xl",
                "wrap": true
              },
              {
                "type": "box",
                "layout": "baseline",
                "margin": "md",
                "contents": rank(recipe)
              },
              {
                "type": "box",
                "layout": "vertical",
                "margin": "lg",
                "spacing": "sm",
                "contents": [
                  {
                    "type": "box",
                    "layout": "baseline",
                    "spacing": "sm",
                    "contents": [
                      {
                        "type": "text",
                        "text": "🥬素材",
                        "color": "#aaaaaa",
                        "size": "sm",
                        "flex": 1
                      },
                      {
                        "type": "text",
                        "wrap": true,
                        "color": "#666666",
                        "size": "xs",
                        "flex": 3,
                        "text": recipe['recipeMaterial'].join(' ')
                      }
                    ]
                  },
                  {
                    "type": "box",
                    "layout": "baseline",
                    "spacing": "sm",
                    "contents": [
                      {
                        "type": "text",
                        "text": "⏰時間",
                        "color": "#aaaaaa",
                        "size": "sm",
                        "flex": 1
                      },
                      {
                        "type": "text",
                        "text": recipe['recipeIndication'],
                        "wrap": true,
                        "color": "#666666",
                        "size": "sm",
                        "flex": 3
                      }
                    ]
                  },
                  {
                    "type": "box",
                    "layout": "baseline",
                    "contents": [
                      {
                        "type": "text",
                        "text": "💰コスト",
                        "flex": 1,
                        "size": "sm",
                        "color": "#aaaaaa"
                      },
                      {
                        "type": "text",
                        "text": recipe['recipeCost'],
                        "flex": 3,
                        "size": "sm",
                        "color": "#666666"
                      }
                    ]
                  }
                ]
              }
            ]
          },
          "footer": {
            "type": "box",
            "layout": "vertical",
            "spacing": "sm",
            "contents": [
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "uri",
                  "label": "webページ",
                  "uri": recipe['recipeUrl']
                }
              },
              {
                "type": "spacer",
                "size": "sm"
              }
            ],
            "flex": 0
          }
        }
      end

      def rank(recipe)
        rank = recipe['rank'].to_i
        ranks = []

        5.times do |i|
          url = if rank > i
              "https://scdn.line-apps.com/n/channel_devcenter/img/fx/review_gold_star_28.png"
            else
              "https://scdn.line-apps.com/n/channel_devcenter/img/fx/review_gray_star_28.png"
            end
          ranks << {
            "type": "icon",
            "size": "sm",
            "url": url
          }
        end

        ranks << {
          "type": "text",
          "text": rank.to_s,
          "size": "sm",
          "color": "#999999",
          "margin": "md",
          "flex": 0
        }
        ranks
      end
    end
  end
end
