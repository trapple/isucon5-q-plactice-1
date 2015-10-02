DIR="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
BENCH_HOME=$DIR/home/bench/
SAMPLE_DATA=$BENCH_HOME/testsets.json

cd $BENCH_HOME

if [ $# -ne 1 ]; then
  echo "引数にIPアドレスが必要です"
  exit;
fi

jq ".[`expr $RANDOM % 20`]" < $SAMPLE_DATA | gradle -q run -Pargs="net.isucon.isucon5q.bench.scenario.Isucon5Qualification $1"
