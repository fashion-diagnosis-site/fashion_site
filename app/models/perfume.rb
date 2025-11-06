class Perfume < ApplicationRecord
    belongs_to :user
    # スタイル番号→名前
    STYLE_NAMES = {
        1 => "アメカジ",
        2 => "ノームコア",
        3 => "ワークスタイル",
        4 => "ストリート",
        5 => "スポーツミックス",
        6 => "テック",
        7 => "韓国系",
        8 => "ゴープコア"
    }.freeze
    
    # 各質問・選択肢 → 加点先スタイル番号（複数）
    # 値は「1〜8の配列」：そのスタイルに+1ずつ加点
    MAPPING = {
        1 => {
        "A" => [4,5,7,6],   # 取り入れたい
        "B" => [1,2,3,8],   # 気にしない
        },
        2 => {
        "A" => [3,5,8,6],   # アウトドア
        "B" => [2,4,7,1],   # インドア
        },
        3 => {
        "A" => [4,5,7,8],   # 派手スニ・サンダル
        "B" => [1,2,3,6],   # シンプルスニ・革靴
        },
        4 => {
        "A" => [4,7,6],     # デザイン
        "B" => [2,3,5,8],   # 着心地
        "C" => [1,2,3],     # 価格
        "D" => [4,5,7],     # 流行
        },
        5 => {
        "A" => [1,2,3,5],   # 町で浮かない落ち着き
        "B" => [4,6,7,8],   # 個性が出る
        },
        6 => {
        "A" => [1,2,3,6,8], # モノトーン/アース
        "B" => [4,5,7],     # 指し色・派手
        },
        7 => {
        "A" => [5,6,8,4],   # ナイロン/機能
        "B" => [1,2,3,7],   # コットン/デニム/レザー
        },
        8 => {
        "A" => [2,3,5,8],   # 実用性
        "B" => [4,6,7],     # おしゃれ
        "C" => [1,3,2],     # クラシック
        "D" => [5,8,6],     # スポーティ
        },
        9 => {
        "A" => [5,4,8,1],   # 元気
        "B" => [2,3,6,1],   # 落ち着いている
        "C" => [4,7,8,6],   # 面白い
        "D" => [2,5,1,7],   # 優しい
        }
    }.freeze
    
    # 回答の取得（"A"/"B"/"C"/"D" など）
    def answers
        [
        question1, question2, question3, question4,
        question5, question6, question7, question8, question9
        ]
    end
    
    VALID_CHOICES = {
        1 => %w[A B],
        2 => %w[A B],
        3 => %w[A B],
        4 => %w[A B C D],
        5 => %w[A B],
        6 => %w[A B],
        7 => %w[A B],
        8 => %w[A B C D],
        9 => %w[A B C D],
    }.freeze
    
    validate :choices_must_be_valid

    def choices_must_be_valid
      answers.each_with_index do |ans, idx|
        q_no = idx + 1
        next if ans.blank? # presenceで拾うのでここではスキップ
        unless VALID_CHOICES[q_no].include?(ans)
          errors.add("question#{q_no}", "の選択肢が不正です")
        end
      end
    end


    # スタイル毎の合計点をハッシュで返す {1=>x, 2=>y, ...}
    def style_counts
        counts = Hash.new(0)
        answers.each_with_index do |ans, idx|
        q_no = idx + 1
        next if ans.blank?
        MAPPING[q_no][ans]&.each { |sid| counts[sid] += 1 }
        end
        # 1..8 を必ずキーとして持たせる
        (1..8).each { |sid| counts[sid] ||= 0 }
        counts
    end
    
    # 同点は番号小さい方優先で上位3つを返す
    # => [{id: 2, name: "ノームコア", count: 7}, ...] * 3
    def top3_styles
        style_counts
        .sort_by { |(sid, cnt)| [-cnt, sid] }
        .first(3)
        .map { |sid, cnt| { id: sid, name: STYLE_NAMES[sid], count: cnt } }
    end
      
    validates :question1, :question2, :question3, :question4,
        :question5, :question6, :question7, :question8, :question9,
        presence: true
end