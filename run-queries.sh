PISA=/path/to/pisa/build/bin
QUERIES=/path/to/queries

mkdir -p runs

echo "Efficiency Runs..."

for index in original doct5query deepimpact; do

  $PISA/queries --encoding block_simdbp \
                --index pisa-index/bp-$index.block_simdbp.idx \
                --wand pisa-index/bp-$index.fixed_40.bmw \
                --terms pisa-index/bp-$index.termlex \
                --algorithm maxscore \
                -k 1000 \
                --scorer quantized \
                --queries $QUERIES/$index.dev.query
  # if you want per-query timings, add --extract
done


for index in unicoil-t5 unicoil-tilde spladev2; do 

  $PISA/queries --encoding block_simdbp \
                --index pisa-index/bp-$index.block_simdbp.idx \
                --wand pisa-index/bp-$index.fixed_40.bmw \
                --terms pisa-index/bp-$index.termlex \
                --algorithm maxscore \
                -k 1000 \
                --scorer quantized \
                --queries $QUERIES/$index.dev.query \
                --weighted \
                --tokenizer whitespace
done

echo "Effectiveness Runs..."
for index in original doct5query deepimpact; do

  $PISA/evaluate_queries --encoding block_simdbp \
                --index pisa-index/bp-$index.block_simdbp.idx \
                --wand pisa-index/bp-$index.fixed_40.bmw \
                --terms pisa-index/bp-$index.termlex \
                --algorithm maxscore \
                -k 1000 \
                --scorer quantized \
                --queries $QUERIES/$index.dev.query
                --documents pisa-index/bp_$index.doclex \
                --run "$index" > runs/$index.dev.trec
done


for index in unicoil-t5 unicoil-tilde spladev2; do 

  $PISA/evaluate_queries --encoding block_simdbp \
                --index pisa-index/bp-$index.block_simdbp.idx \
                --wand pisa-index/bp-$index.fixed_40.bmw \
                --terms pisa-index/bp-$index.termlex \
                --algorithm maxscore \
                -k 1000 \
                --scorer quantized \
                --queries $QUERIES/$index.dev.query \
                --weighted \
                --tokenizer whitespace \
                --documents pisa-index/bp_$index.doclex \
                --run "$index" > runs/$index.dev.trec
done


