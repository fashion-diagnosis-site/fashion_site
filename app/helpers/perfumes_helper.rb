module PerfumesHelper
  STYLE_SLUGS = {
    1 => "amekaji",
    2 => "normcore",
    3 => "work",
    4 => "street",
    5 => "sportsmix",
    6 => "tech",
    7 => "korean",
    8 => "gorpcore",
  }.freeze

  # ▼ ここに各スタイルごとの「参照先URL（最大5件）」を記入
  #    空ならリンクなしで表示されます。必要に応じて編集してください。
  STYLE_LINKS = {
    1 => [ # アメカジ
      "https://www.instagram.com/mrkaisey/p/DQoQQyJEi1R",
      "https://www.instagram.com/mrkaisey/p/DQoQQyJEi1R",
      "https://example.com/amekaji/3",
      "https://example.com/amekaji/4",
      "https://example.com/amekaji/5",
    ],
    2 => [ # ノームコア
      "https://example.com/normcore/1",
      "https://example.com/normcore/2",
      "https://example.com/normcore/3",
      "https://example.com/normcore/4",
      "https://example.com/normcore/5",
    ],
    3 => [ # ワークスタイル
      "https://example.com/work/1",
      "https://example.com/work/2",
      "https://example.com/work/3",
      "https://example.com/work/4",
      "https://example.com/work/5",
    ],
    4 => [ # ストリート
      "https://example.com/street/1",
      "https://example.com/street/2",
      "https://example.com/street/3",
      "https://example.com/street/4",
      "https://example.com/street/5",
    ],
    5 => [ # スポーツミックス
      "https://www.instagram.com/p/DAnXOw8P28e",
      "https://example.com/sportsmix/2",
      "https://example.com/sportsmix/3",
      "https://example.com/sportsmix/4",
      "https://example.com/sportsmix/5",
    ],
    6 => [ # テック
      "https://example.com/tech/1",
      "https://example.com/tech/2",
      "https://example.com/tech/3",
      "https://example.com/tech/4",
      "https://example.com/tech/5",
    ],
    7 => [ # 韓国系
      "https://example.com/korean/1",
      "https://example.com/korean/2",
      "https://example.com/korean/3",
      "https://example.com/korean/4",
      "https://example.com/korean/5",
    ],
    8 => [ # ゴープコア
      "https://example.com/gorpcore/1",
      "https://example.com/gorpcore/2",
      "https://example.com/gorpcore/3",
      "https://example.com/gorpcore/4",
      "https://example.com/gorpcore/5",
    ],
  }.freeze

  # 既存：存在する画像を返す
  def style_image_paths(style_id)
    slug = STYLE_SLUGS[style_id]
    (1..5).map { |i| find_first_existing_asset("styles/#{slug}/#{i}") }.compact
  end

  # ▼ 新規：画像とURLのペア配列を返す（最大5件）
  #     [{src: "styles/amekaji/1.jpg", href: "https://..."}, ...]
  def style_cards(style_id)
    slug = STYLE_SLUGS[style_id]
    links = STYLE_LINKS[style_id] || []
    cards = []

    (1..5).each do |i|
      src = find_first_existing_asset("styles/#{slug}/#{i}")
      next unless src # 画像が無ければスキップ
      href = links[i - 1].presence
      cards << { src: src, href: href }
    end

    cards
  end

  # 既存：拡張子自動判定
  def find_first_existing_asset(basename_without_ext)
    %w[.jpg .jpeg .png .webp].each do |ext|
      path = "#{basename_without_ext}#{ext}"
      return path if asset_exists?(path)
    end
    nil
  end

  # 既存：アセット存在確認（Sprockets/Propshaft対応）
  def asset_exists?(logical_path)
    if defined?(Rails.application.assets_manifest) && Rails.application.assets_manifest
      manifest = Rails.application.assets_manifest
      return true if manifest.assets&.key?(logical_path)
    end

    if defined?(Rails.application.assets) && Rails.application.assets
      return Rails.application.assets.find_asset(logical_path).present?
    end

    public_path = Rails.root.join("public", "assets", logical_path)
    return true if File.exist?(public_path)

    false
  end

  def style_label(style_id)
    Perfume::STYLE_NAMES[style_id]
  end
end