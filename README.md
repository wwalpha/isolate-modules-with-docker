# Isolate Modules With Docker

背景、課題、方法論、見込効果、やり方、実際効果の順番で説明する

## なにやってのか

CI ツールの CloudBuild を使って、毎回`yarn install`、`yarn buld`、`yarn test`の順に実行しています。

## なぜやるのか

**`yarn install`の時間が長い（１分ほど）**、毎回インストールする時間が無駄になりますので、なんとうか解消できるかを考えました。

## どうやるのか

- `yarn.lock` を Cloud Storage に保存し、Install する前に取り出す。Install の計算時間を減ることができる
- 新しい CloudBuild Trigger を追加し、レポジトリにある `package.json` が変更されたら、`yarn install` を実行後、`node_modules` フォルダを圧縮してから、Cloud Storage に転送する。Source Build 時、Cloud Storage から取り出し、解凍してから `yarn build` を実行する
- 新しい CloudBuild Trigger を追加し、レポジトリにある `package.json` が変更されたら、`node_modules` を含む `Docker Image` を作成し、Container Registry に保存する。Source Build 時、ビルド済みの Docker Image をベースに、Local source と Build Output のフォルダをマウントして、コンテナ内でビルドを行う、Build Output フォルダのファイルは `yarn test` に使う

## どっちにするのか

- １番目の方法は、50% 以上の短縮は見込めない
- ２番目の方法は、効果は見込めるが、実装方法イマイチ、力技に過ぎない
- ３番目の方法は、**効果、仕組みなど一番よい**

## どうやったのか

## どうのこうかがあるのか
