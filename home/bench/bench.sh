BENCH_HOME=/home/isucon/bench/
SAMPLE_DATA=/home/isucon/bench/testsets.json
cd $BENCH_HOME
jq '.[0]' < $SAMPLE_DATA | gradle -q run -Pargs="net.isucon.isucon5q.bench.scenario.Isucon5Qualification 127.0.0.1"
