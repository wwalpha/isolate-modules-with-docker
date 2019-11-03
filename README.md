# Isolate node-modules With Docker

背景、課題、方法論、見込効果、やり方、実際効果の順番で説明する

## Background

CI ツールの CloudBuild を使って、毎回`yarn install`、`yarn buld`、`yarn test`の順に実行しています。

## Issue

**`yarn install`の時間が長い（１分ほど）**、毎回インストールする時間が無駄になりますので、なんとうか解消できるかを考えました。

## Methodology

### Method1

`yarn.lock` を Cloud Storage に保存し、Install する前に取り出す。Install の計算時間を減ることができる

### Method2

- `package.json`に対して、新しい CloudBuild Trigger を追加し、`yarn install`を実行する
- Install 完了後、`node_modules` を圧縮し、Cloud Storage に保存する
- Source Build 時、Cloud Storage から取り出し、解凍してから `yarn build`、`yarn test` を実行する

### Method3

- `package.json`に対して、新しい CloudBuild Trigger を追加し、`yarn install`を実行する
- Install 完了後、`node_modules` を含む **Docker Image** を作成し、Container Registry に保存する
- Source Build 時、ビルド済みの Docker Image をベースに、Local Source と Build Output のフォルダをマウントして、コンテナ内でビルドを行う
- Build Output は Source 側にマウントされているので、そのまま `yarn test`を実行する

## Which Methodology ?

- １番目の方法は、50% 以上の短縮は見込めない
- ２番目の方法は、効果は見込めるが、実装方法**ダサイ**、力技に過ぎない
- ３番目の方法は、**効果、仕組みなど一番よい**

## How ?

### Create Docker Image

[Dockerfile](./Dockerfile)

```
$ docker build -t node-modules .
$ docker images


```

Build 結果確認

```
$ docker images
```

### Use Docker Image to build

[docker-compose.yaml](./docker-compose.yaml)

```
$ docker-compose up
$
```

### Check Results

## What's the point ?

`build/index.js` がホスト側に作成される

## どうのこうかがあるのか
