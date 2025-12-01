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
      "https://www.instagram.com/mdaros_kei?igsh=b21jcGVycm5xOHJr",
      "https://www.instagram.com/__00_rui?igsh=NXpxZmdwcWVsNmcz",
      "https://www.instagram.com/iannnnnn1009?igsh=NmFpZmdyMzloZXRl",
      "https://www.instagram.com/ichireen0411?igsh=MWc1ZXdqc3NzYTdvNw==",
      "https://www.instagram.com/ty.yu880?igsh=emozb2Z2YWh5N2Nm",
    ],
    2 => [ # ノームコア
      "https://www.instagram.com/taiyo_wup?igsh=MWtzaXB3aXhwbjl4bw==",
      "https://www.instagram.com/sunp0s?igsh=MW1rZm9qZDB0Zjh0OA==",
      "https://www.instagram.com/kochanfvnofuku?igsh=Nzk1ZmVveXZheWNt",
      "https://www.instagram.com/187___.___?igsh=MTVyZG82NmtrZmh0aQ==",
      "https://www.instagram.com/_______kite.24?igsh=MWtmNjZ2OTgxYmpsag==",
    ],
    3 => [ # ワークスタイル
      "https://www.instagram.com/13shop_toyota?igsh=OXRhamg3Y3ZyN252",
      "https://www.instagram.com/willhalbert?igsh=anB6Y2djMTA5NTNo",
      "https://www.instagram.com/13shop_yuki?igsh=MWlkcDF1bnh6ZmE1MQ==",
      "https://www.instagram.com/xx1.18xx?igsh=MWl5eWZnNmh5bWxveQ==",
      "https://www.instagram.com/ryoya.115?igsh=ZXNrYnNsbGx3eWh2",
    ],
    4 => [ # ストリート
      "https://www.instagram.com/tig___00?igsh=MWNiY2pnZjN0c3BiZQ==",
      "https://www.instagram.com/___hwts?igsh=bXJwZTFmZzhkY3hw",
      "https://www.instagram.com/imrobinjay?igsh=d2Vkbjd6YzBybGlr",
      "https://www.instagram.com/kz._.03?igsh=OGkzaHpod21oYW0=",
      "https://www.instagram.com/gvbrielrios?igsh=OWRhb3A1b2s3anlj",
    ],
    5 => [ # スポーツミックス
      "https://www.instagram.com/makoto_97_o0?igsh=MWlxemhiZjFyNGlwZQ==",
      "https://www.instagram.com/jun_wear45?igsh=MWRpbHhoNDNtMnVkMw==",
      "https://www.instagram.com/0rl____io3?igsh=ZW1yMGltYms5amtn",
      "https://www.instagram.com/itoooossi?igsh=ZHF3d3lhNm45MTV6",
      "https://www.instagram.com/kojikun0909?igsh=MWp0dWxxdWtscG02cQ==",
    ],
    6 => [ # テック
      "https://www.instagram.com/zkunn_dayooooo?igsh=MXF1dDB3ejIxdXUyNg==",
      "https://www.instagram.com/ksasaki062414?igsh=NGhpbnR6cHEybDYz",
      "https://www.instagram.com/ks_12uk?igsh=MWFkc2M5ajE5NzF3bQ==",
      "https://www.instagram.com/i_am_kentadesu_?igsh=ZHMxNHdneHQ4dHp5",
      "https://www.instagram.com/wa10_son?igsh=OWhlbnQyZzY3aHk5",
    ],
    7 => [ # 韓国系
      "https://www.instagram.com/s.__.ka_512?igsh=dDc0OTRiOHU4eDY4",
      "https://www.instagram.com/_3.zik.x?igsh=ZTV3dXNkdWVwempr",
      "https://www.instagram.com/syuu._.wear?igsh=MWt2N3l2d3ZuaTdhNA==",
      "https://www.instagram.com/woozaet?igsh=MW1peWlubzE4dGUxdg==",
      "https://www.instagram.com/keisho_0624?igsh=bThjeXZrcXZrNWc2",
    ],
    8 => [ # ゴープコア
      "https://www.instagram.com/shoxtaxx?igsh=b2poaW1mbmdhdjV6",
      "https://www.instagram.com/y_marron0408?igsh=b3BjNHhoa2kwdXZ4",
      "https://www.instagram.com/s_h_u.22?igsh=MTk5djNzeGdpb3QzbQ==",
      "https://www.instagram.com/_99_ryu?igsh=MXUwdmN6OW9zeDZlMQ==",
      "https://www.instagram.com/shin___813?igsh=MWNyc2c4NDl1OWh3cg==",
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