# Isolate node-modules With Docker

背景、課題、方法論、見込効果、やり方、実際効果の順番で説明する

## Background

CI ツールの CloudBuild を使って、毎回`yarn install`、`yarn buld`、`yarn test`の順に実行しています。

<br />

## Issue
ライブラリのインストール時間が長い（１分超え）、毎回の実行時間が無駄になりますので、なんとうか解消できるかを考えました。

<br />

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

<br />

## Test methodology locally

### Create Docker Image
[Dockerfile](./Dockerfile)

```
$ docker build -t node-modules .
Successfully built 18538e83ac54
Successfully tagged node-modules:latest

$ docker images
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
node-modules               latest              18538e83ac54        49 seconds ago      143MB
```

### Use Docker Image to build

[docker-compose.yml](./docker-compose.yml)

```
$ docker-compose up -d
Starting isolate-modules-with-docker_test_1 ... done

$ ls build
-rw-r--r-- 1 root root 306 Nov  3 11:10 index.js
```

<br />

## What's the point ?
Local folder と Container 共有時、Container 内部の `node_modules` folderがなくなってしまったため、`- /workspace/node_modules` 最後、内部のフォルダ再マウントすると、問題解決できます。

```
volumes:
  - .:/workspace　　　　　　　
  - ./build:/workspace/build
  - /workspace/node_modules
```

## Finalise version

## どうのこうかがあるのか
