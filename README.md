# Gretel

## 概要

Minecraft Spigot の実行環境

## 使い方

### ゲームサーバ実行方法
- ローカル

```sh
cp .env.sample .env
docker-compose up -d
```

### アップデート方法
- `.env`の`MINECRAFT_VERSION`に指定したバージョンを変更し、Docker Imageを作り直す
```
# .env
- MINECRAFT_VERSION=1.17.4
+ MINECRAFT_VERSION=1.18.1
```
```sh
dokcer-compose up --build -d
```

注意 : アップデート直後はワールドデータの更新を行うため、起動時間が通常よりも長くなることがあります

### ゲームサーバの移行方法
- `.env`の`SPIGOT_DIR`に指定したディレクトリをコピーする
