# どどんとふ用 Munin プラグイン
[Munin](http://www.munin-monitoring.org/) で[どどんとふ](http://www.dodontof.com/)の状態を監視するためのプラグインです。hogy 氏が [RollPlus.Org](http://www.rollplus.org/) で公開されている「どどんとふ利用情報グラフ化Muninプラグイン」がベースになっています。

## 動作環境
Ruby 2.0.0 以上が必要です。どどんとふのデータを MySQL で管理している場合、部屋使用状況監視用の dodontof_rooms は使用できません。

## 準備
[Releases](https://github.com/ochaochaocha3/munin-dodontof/releases) ページより最新版をダウンロードし、適当なディレクトリに展開してください。

展開後、各プラグインファイルの設定項目（`CONFIG_DIR`、`SAVEDATA_DIR` 等）をどどんとふの環境に合わせて修正します。また、rbenv 等を使用している場合は先頭の `#!` の部分の Ruby のパスを環境に合わせて修正してください。

修正したら、以下のコマンドを実行して Munin にプラグインを追加してください。

```sh
# 展開したディレクトリ上で作業していることを仮定

# ローカルプラグインディレクトリを表す環境変数を定義する
LOCAL_PLUGINS=/usr/local/munin/lib/plugins
# ローカルプラグインディレクトリを作成する
sudo mkdir -p $LOCAL_PLUGINS
# ローカルプラグインディレクトリにプラグインをコピーする
sudo cp dodontof_* $LOCAL_PLUGINS
# 実行権限を与える
sudo chmod 755 $LOCAL_PLUGINS/dodontof_*
# シンボリックリンクを作成する
sudo ln -s $LOCAL_PLUGINS/dodontof_* /etc/munin/plugins
```

参考：[Using munin plugins — Munin documentation](http://guide.munin-monitoring.org/en/latest/plugin/use.html)

プラグイン追加後、念のため `autoconf` でプラグインが実行可能であることを確認してください。`yes` が出力されれば実行可能です。`no` が出力された場合、設定を再度確認してください。

```sh
sudo munin-run dodontof_users autoconf
sudo munin-run dodontof_rooms autoconf
```

プラグインが実行可能であることを確認できたら、munin-node を再起動してください。

```sh
# SysVinit の場合
sudo service munin-node restart

# systemd の場合
sudo systemctl restart munin-node
```

5 分程度経過後、Munin に `dodontof` が追加されていることを確認してください。

## ライセンス
[MIT License](LICENSE.md)
