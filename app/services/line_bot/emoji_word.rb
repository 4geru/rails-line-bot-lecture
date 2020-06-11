# frozen_string_literal: true

module LineBot
  class EmojiWord
    def translate_to_emoji(text)
      emoji_list = []

      translatec_text = text.chars.map do |char|
        if japanese_words_index(char)
          emoji_list <<
            {
              "productId": "5ac21ba5040ab15980c9b441",
              "emojiId": "%03d" % (japanese_words_index(char) + 1)
            }

          '$'
        elsif english_words_index(char)
          emoji_list <<
            {
              "productId": "5ac21a8c040ab15980c9b43f",
              "emojiId": "%03d" % (english_words_index(char) + 1)
            }

          '$'
        else
          char
        end
      end.join('')
      [translatec_text, emojis(translatec_text, emoji_list)]
    end

    private

    def emojis(text, array)
      indexs = doller_indexs(text)
      indexs.each.with_index do |v, i|
        array[i]['index'] = v
      end

      array
    end

    def doller_indexs(str)
      str.chars.map.with_index { |v, i| v == '$' ? i : nil }.compact
    end

    def japanese_words_index(char)
      # ref: https://qiita.com/kiseragi/items/a0e07db26351ec2ef67b
      words = """
        あいうえお
        かきくけこ
        さしすせそ
        たちつてと
        なにぬねの
        はひふへほ
        まみむめも
        やゆよ
        らりるれろ
        わをん
        ぁぃぅぇぉ
        っ
        ゃゅょ
        がぎぐげご
        ざじずぜぞ
        だぢづでど
        ばびぶべぼ
        ぱぴぷぺぽ

        アイウエオ
        カキクケコ
        サシスセソ
        タチツテト
        ナニヌネノ
        ハヒフヘホ
        マミムメモ
        ヤユヨ
        ラリルレロ
        ワヲン
        ァィゥェォ
        ッ
        ャュョ
        ガギグゲゴ
        ザジズゼゾ
        ダヂヅデド
        バビブベボ
        パピプペポ

        ー
      """
      words.gsub(/[\n| ]/, '').chars.index(char)
    end

    def english_words_index(char)
      # ref: https://qiita.com/kiseragi/items/a0e07db26351ec2ef67b
      words = <<~EOS
        ABCDEFGHIJKLMNOPQRSTUVWXYZ
        abcdefghijklmnopqrstuvwxyz
        0123456789
      EOS
      words.gsub(/[\n| ]/, '').chars.index(char)
    end
  end
end
