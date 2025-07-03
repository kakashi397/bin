#!/bin/bash

# 🚀 引数でプロジェクト名を受け取る
project_name=$1

# ❗プロジェクト名が空なら警告を出して終了
if [ -z "$project_name" ]; then
  echo "⚠️ プロジェクト名を指定してください"
  exit 1
fi

# 🧼 プロジェクト名の確認
echo "📦 作成するプロジェクト名：$project_name"
read -p "この名前で進めてもよろしいですか？ [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "🚫 キャンセルされました"
  exit 1
fi

# 📁 プロジェクトフォルダを作成して移動
mkdir "$project_name" && cd "$project_name"

# 🧱 ローカル初期構築
npm init -y
cp ~/DevTemplates/.gitignore .gitignore
mkdir -p sass css js
touch index.html js/script.js
npm install --save-dev sass
git init
git branch -M main
npm pkg set scripts.watch="sass ./sass:./css --watch"

# 🧱 FLOCSS構成ディレクトリ追加
mkdir -p sass/foundation sass/layout sass/object/component sass/object/project sass/object/utility

# 📝 foundationファイル群
touch sass/foundation/_keyframes.scss
touch sass/foundation/_reset.scss
touch sass/foundation/_variables.scss
touch sass/foundation/_mixins.scss
cat << 'EOF' > sass/foundation/_mixins.scss@use 'sass:map';
@use 'sass:math';

// メディアクエリ用ブレイクポイント定義
$breakpoints: (
  s : "(min-width: 375px)",
  m : "(min-width: 767px)",
  l : "(min-width: 991px)",
  xl: "(min-width: 1199px)",
);

@mixin media ($breakpoint) {
  @if map.has-key($breakpoints, $breakpoint) {
    @media #{map.get($breakpoints, $breakpoint)} {
      @content;
    }
  }
  @else {
    @error "$breakpoints に #{$breakpoint} ってキーは無いぜ";
  }
}
EOF

touch sass/foundation/_functions.scss
cat << 'EOF' > sass/foundation/_functions.scss
@use 'sass:math';

// px→rem(16pxをベースとした場合)
@function rem($pixels, $context: 16) { 
  @return math.div($pixels, $context) * 1rem;
}

// clamp()ジェネレータ
@function clamp-rem($min-vw, $min-size, $max-vw, $max-size, $base-font-size: 16) {
  $slope: ($max-size - $min-size) / ($max-vw - $min-vw) * 100;
  $intercept: $min-size - ($slope * $min-vw / 100);

  $min-rem: $min-size / $base-font-size * 1rem;
  $max-rem: $max-size / $base-font-size * 1rem;
  $intercept-rem: $intercept / $base-font-size * 1rem;

  @return clamp(#{$min-rem}, #{$intercept-rem} + #{$slope}vw, #{$max-rem});
}

// %変換ジェネレータ
@function to-percent($value, $base) {
  @if math.unitless($value) {
    $value: $value * 1px;
  }
  @if math.unitless($base) {
    $base: $base * 1px;
  }
  @return math.div($value, $base) * 100%;
}

// スケール関数
@function scale($base, $value, $target) {
  @return ($value / $base) * $target;
}
EOF

touch sass/foundation/_base.scss

# 📘 _setting.scss（foundationのみ読み込み）
cat << EOF > sass/_setting.scss
@use "foundation/functions";
@use "foundation/mixins";
@use "foundation/variables";
@use "foundation/reset";
@use "foundation/base";
EOF

# 🎨 style.scss（settingを読み込み）
echo '@use "setting";' > sass/style.scss

# 🧬 Gitステージング＆初期コミット
git add .
git commit -m "初期コミット"

# 🌐 リモートリポジトリ作成の確認
read -p "GitHubにリポジトリを作成してpushしますか？ [y/N]: " push_confirm
if [[ "$push_confirm" =~ ^[Yy]$ ]]; then
  # パブリック or プライベート選択
  read -p "リポジトリをパブリックにしますか？（Yesでパブリック / Noでプライベート） [y/N]: " pub_confirm
  if [[ "$pub_confirm" =~ ^[Yy]$ ]]; then
    repo_visibility="--public"
  else
    repo_visibility="--private"
  fi

  gh repo create "$(basename "$PWD")" $repo_visibility --source=. --remote=origin --push
  echo "✅ リモートリポジトリ（$repo_visibility）を作成し、pushしました！"
else
  echo "📁 ローカルレポジトリのみ作成されました（GitHub未接続）"
fi


# 💻 VSCodeで開く
code -r .

# 🎉 完了メッセージ
echo "✅ '$project_name' プロジェクトのFLOCSS構成初期化が完了しました！"
