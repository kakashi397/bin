ChatGPTに要望を伝えて作っています。

✅ このスクリプトでできること
引数からプロジェクト名を受け取る（未指定なら中止）

プロジェクト名を確認（yes/no）

プロジェクトフォルダを作成＆移動

Node.js プロジェクトを初期化（npm init -y）

.gitignore をテンプレートからコピー

sass, css, js ディレクトリを作成

初期ファイルを作成（index.html, js/script.js）

Sass を開発用パッケージとしてインストール

Git リポジトリを初期化し、main ブランチに変更

Sass の自動コンパイルスクリプトを設定（npm run watch）

FLOCSS構成のディレクトリを一式作成

Foundation系の Sass ファイル群を自動生成

_setting.scss に foundation のモジュールを読み込む記述を自動生成

style.scss に @use "setting"; を記述

Git ステージング＆初期コミット（"初期コミット"）

GitHubリポジトリを作成するか選べる（yes/no）

作成する場合は パブリック／プライベート どちらかを選べる

gh repo create で作成＆pushまで自動

VSCodeでプロジェクトを開く

最後に完了メッセージを表示✨

