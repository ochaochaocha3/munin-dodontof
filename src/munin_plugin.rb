# Munin プラグインクラス
class MuninPlugin
  # コンストラクタ
  #
  # ブロック付きの場合は内部で config 等を定義することができる
  def initialize(&block)
    @config_proc = Proc.new {}
    @fetch_proc = Proc.new {}

    instance_eval(&block) if block
  end

  # config コマンドで実行する処理を設定する
  # @return [self]
  # @yield config コマンドで実行する処理
  # @yieldparam c [Hash] 設定を格納するハッシュ
  def config(&config_proc)
    @config_proc = config_proc
    self
  end

  # データ取得処理を設定する
  # @return [self]
  # @yield データ取得処理
  # @yieldparam result [Hash] 取得したデータを格納するハッシュ
  def fetch(&fetch_proc)
    @fetch_proc = fetch_proc
    self
  end

  # プラグインの処理を実行する
  def run
    case ARGV.length
    when 0
      begin
        do_fetch
      rescue => fetch_error
        print_error(fetch_error)
        abort
      end

      exit
    when 1
      if ARGV[0] == 'config'
        begin
          do_config
        rescue => config_error
          print_error(config_error)
          abort
        end
      else
        print_usage
        abort
      end
    else
      print_usage
      abort
    end
  end

  private

  def do_config
    config_data = {}

    @config_proc[config_data]

    config_data.each do |k, v|
      puts("#{k} #{v}")
    end
  end

  def do_fetch
    result = {}

    @fetch_proc[result]

    result.each do |k, v|
      puts("#{k}.value #{v}")
    end
  end

  def print_usage
    $stderr.puts("Usage: #{File.basename($PROGRAM_NAME)} [config]")
  end

  def print_error(e)
    $stderr.puts("#{e.class}: #{e}")
  end
end
