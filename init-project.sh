#!/bin/bash

# 🚀 引数でプロジェクト名を受け取る
project_name=$1

# ❗プロジェクト名が空なら警告を出して終了
if [ -z "$project_name" ]; then
  echo "⚠️ プロジェクト名を指定してください"
  exit 1
fi

# 📁 プロジェクトフォルダを作成して移動
mkdir "$project_name" && cd "$project_name"

# 🧱 初期構築
npm init -y && \
cp ~/DevTemplates/.gitignore ./ && \
mkdir -p sass css js && \
touch index.html sass/style.scss js/script.js && \
npm install --save-dev sass && \
git init && \
git branch -M main && \
npm pkg set scripts.watch="sass ./sass:./css --watch" && \
gh repo create "$(basename "$PWD")" --private --source=. --remote=origin --push && \
code -r .

# 🎉 完了メッセージ
echo "✅ '$project_name' プロジェクトの初期構築が完了しました！"



# 🎉 完了メッセージ
echo "✅ '$project_name' プロジェクトの初期構築が完了しました！"
