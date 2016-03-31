# どどんとふ用 Munin プラグイン
[Munin](http://www.munin-monitoring.org/) で[どどんとふ](http://www.dodontof.com/)の状態を監視するためのプラグインです。hogy 氏が [RollPlus.Org](http://www.rollplus.org/) で公開されている「どどんとふ利用情報グラフ化Muninプラグイン」がベースになっています。

## 動作環境
Ruby 2.0.0 以上が必要です。どどんとふのデータを MySQL で管理している場合、部屋使用状況監視用の dodontof_rooms は使用できません。

## 準備
[Releases](https://github.com/ochaochaocha3/munin-dodontof/releases) ページより最新版をダウンロードし、適当なディレクトリに展開してください。

展開後、設定ファイル plugin-conf.d/dodontof\_.sample をコピーして plugin-conf.d/dodontof\_ というファイルを作成し、どどんとふの環境に合わせて修正します。

```
[dodontof_*]
env.config_dir 設定ファイル config.rb があるディレクトリの絶対パス
env.savedata_dir saveDataディレクトリの絶対パス

[dodontof_rooms]
env.warn_percentage 警告を発し始める部屋の使用率（%）
```

また、rbenv 等を使用している場合はプラグイン先頭の `#!` の部分の Ruby のパスを環境に合わせて修正してください。

修正したら、以下のコマンドを実行して Munin にプラグインを追加してください。

```sh
# 展開したディレクトリ上で作業していることを仮定
sudo rake install
```

プラグイン追加後、munin-node を再起動してください。

```sh
# SysVinit の場合
sudo service munin-node restart

# systemd の場合
sudo systemctl restart munin-node
```

5 分程度経過後、Munin に `dodontof` が追加されていることを確認してください。

## 開発
src 以下にソースコードが格納されています。共通部分はファイル munin\_config.rb に分離されていますが、以下のコマンドで 1 つのプラグインファイルに結合することができます。修正後は必ず実行してください。

```sh
# 例：dodontof_rooms の場合
rake dodontof_rooms
```

## ライセンス
[MIT License](LICENSE)
