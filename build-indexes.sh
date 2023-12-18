CIFF=/path/to/ciff
PISA=/path/to/pisa/build/bin

mkdir -p pisa-canonical
mkdir -p pisa-index

# All CIFF files we provide are pre-quantized. If you don't have a pre-quantized
# CIFF file, please make an issue on the repo and ask us how to handle the indexing.
echo "Building Indexes that are pre-quantized"
for index in ; do 

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
