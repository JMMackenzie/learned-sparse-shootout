CIFF=/path/to/ciff
PISA=/path/to/pisa/build/bin

mkdir -p pisa-canonical
mkdir -p pisa-index

echo "Building Non-Quantized Indexes..."
for index in bp-original bp-doct5query; do 

  # Convert the CIFF file to PISA's input format
  echo "Running ciff2pisa"
  ciff2pisa --ciff-file $CIFF/$index.ciff --output pisa-canonical/$index

  echo "Build WAND metadata using fixed-blocks (size = 40), quantize"
  $PISA/create_wand_data --collection pisa-canonical/$index --block-size 40 --scorer bm25 --bm25-k1 0.82 --bm25-b 0.68 --quantize --output pisa-index/$index.fixed_40.bmw

  # Index the pisa files
  echo "Compress invidx plus quantize tf vals"
  $PISA/compress_inverted_index --encoding block_simdbp --collection pisa-canonical/$index --output pisa-index/$index.block_simdbp.idx --wand pisa-index/$index.fixed_40.bmw --scorer bm25 --bm25-k1 0.82 --bm25-b 0.68 --quantize


  echo "Build the term and document mappings"
  $PISA/lexicon build pisa-canonical/$index.documents pisa-index/$index.doclex
  $PISA/lexicon build pisa-canonical/$index.terms pisa-index/$index.termlex

done


echo "Building Indexes that are pre-quantized"
for index in bp-deepimpact bp-unicoil-t5 bp-unicoil-tilde bp-spladev2; do 

  # Convert the CIFF file to PISA's input format
  echo "Running ciff2pisa"
  ciff2pisa --ciff-file $CIFF/$index.ciff --output pisa-canonical/$index

  # Index the pisa files
  echo "Compress invidx"
  $PISA/compress_inverted_index --encoding block_simdbp --collection pisa-canonical/$index --output pisa-index/$index.block_simdbp.idx

  echo "Build WAND metadata using fixed-blocks (size = 40)"
  $PISA/create_wand_data --collection pisa-canonical/$index --block-size 40 --scorer quantized --output pisa-index/$index.fixed_40.bmw

  echo "Build the term and document mappings"
  $PISA/lexicon build pisa-canonical/$index.documents pisa-index/$index.doclex
  $PISA/lexicon build pisa-canonical/$index.terms pisa-index/$index.termlex

done
