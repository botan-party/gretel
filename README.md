# Gretel

## 概要

Minecraft Spigot サーバを運用するためのサービス

## 動作環境(EC2)

- OS: Amazon Linux 2
- Instance Type: t2.medium
- Security Group:
  - TCP: 22
  - TCP: 25565
  - UDP: 25565

## 使い方

### インストール方法

- EC2 インスタンスに SSH 接続して以下を実行する

```sh
sudo yum install -y git
git clone https://github.com/shokkunrf/gretel.git
cd ./gretel
bash ./setup.sh install <Minecraft Version>
```

- docker imageを利用して手元のマシンからEC2インスタンスをセットアップする

```sh
docker run --volume=$HOME/.ssh/<IDENTITY_FILE.pem>:/workspace/identity.pem ghcr.io/shokkunrf/gretel-provisioner:latest --minecraft <MINECRAFT_VERSION> -h <USER>@<IP_ADDRESS>
```

Ansible が利用可能なdockerイメージを使い、自動的にセットアップを実行することが可能です。
インストール後は「ゲームサーバ実行方法」の項にしたがってサーバーを実行してください。

### ゲームサーバ実行方法

- EC2 インスタンス起動時に自動で起動する
- 以下で手動で起動/停止する場合、 EC2 インスタンスに SSH 接続して以下を実行する

```sh
# start
sudo systemctl start spigot
# stop
sudo systemctl stop spigot
```

### ゲームサーバの移行方法

- ローカルから EC2 インスタンスへ, EC2 インスタンスからローカルへサーバディレクトリをコピーする

```sh
# import
scp -r ./<サーバディレクトリ> ec2-user@<ipアドレス>:~/opt/spigot
# export
scp -r ec2-user@<ipアドレス>:~/opt/spigot ./<サーバディレクトリ>
```

### アップデート方法

```sh
bash ./setup.sh update <Minecraft Version>
```

注意 : アップデート直後はワールドデータの更新を行うため、起動時間が通常よりも長くなることがあります

