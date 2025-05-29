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
touch sass/foundation/_reset.scss
touch sass/foundation/_variables.scss
touch sass/foundation/_mixin.scss
touch sass/foundation/_functions.scss
touch sass/foundation/_base.scss

# 📘 _setting.scss（foundationのみ読み込み）
cat << EOF > sass/_setting.scss
@use "foundation/functions";
@use "foundation/mixin";
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
read -p "GitHubにプライベートリポジトリを作成してpushしますか？ [y/N]: " push_confirm
if [[ "$push_confirm" =~ ^[Yy]$ ]]; then
  gh repo create "$(basename "$PWD")" --private --source=. --remote=origin --push
  echo "✅ リモートリポジトリを作成し、pushしました！"
else
  echo "📁 ローカルレポジトリのみ作成されました（GitHub未接続）"
fi

# 💻 VSCodeで開く
code -r .

# 🎉 完了メッセージ
echo "✅ '$project_name' プロジェクトのFLOCSS構成初期化が完了しました！"
