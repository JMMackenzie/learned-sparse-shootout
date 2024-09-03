# learned-sparse-shootout

This repository aims to support the experimentation provided in the TOIS 2023 paper **Efficient Document-at-a-time and Score-at-a-time Query Evaluation for Learned Sparse Representations** which was perhaps better known by its pre-print title **Wacky Weights in Learned Sparse Representations and the Revenge of Score-at-a-Time Query Evaluation**.

## Reference
This work appeared in ACM TOIS in 2023. Please cite our TOIS paper if you use this code repository.

```
@article{wacky-tois,
author = {Mackenzie, Joel and Trotman, Andrew and Lin, Jimmy},
title = {Efficient Document-at-a-Time and Score-at-a-Time Query Evaluation for Learned Sparse Representations},
year = {2023},
volume = {41},
number = {4},
doi = {10.1145/3576922},
journal = {ACM Trans. Inf. Syst.},
articleno = {96},
numpages = {28},
}
```

## Data
You will require a unique URL with a password to get the data due to the old data storage platform being decommissioned.
Please create a github issue or contact Joel directly: joel.mackenzie@uq.edu.au

## Overview

You need to do three main things to reproduce the experiments.

1. Get the data: ~`get-data.sh`~ See above.
2. Build the indexes: `build-indexes.sh`
3. Run the queries/experiments: `run-queries.sh`

## Dependencies and Workflow

This section briefly outlines the process required to index the data and run the experiments. We make extensive use of [Anserini](https://github.com/castorini/anserini) for our indexing as well as the [CIFF](https://github.com/osirrc/ciff) tool to export the indexes.
The resulting CIFF file is then reordered to improve index compression using the [enhanced graph bisection tool](https://github.com/JMMackenzie/enhanced-graph-bisection). The CIFF indexes are then exported to PISA's format via the [PISA's CIFF tool](https://github.com/pisa-engine/ciff).
[PISA](https://github.com/pisa-engine/pisa/) or [JASSv2](https://github.com/andrewtrotman/JASSv2) are then used for the remaining experimentation.

The workflow is as follows:
1. The base data (usually a `.json` file or a set of `.json` files) is indexed using Anserini.
2. The Anserini indexes is exported to CIFF (the common index file format).
3. The resultant CIFF file, which represents the entire index (including document identifiers, lexicon, postings, ...) is reordered using the enhanced-graph-bisection tool; this step is optional but it improves index compression and accelerates query processing for both PISA and JASS.
4. The resulting CIFF file can be indexed:
  - PISA: Convert the CIFF file to PISA's format, and then index with PISA.
  - JASS: Directly index from the CIFF file.

## Other Resources

The [PISA documentation](https://pisa-engine.github.io/pisa/book/guide/indexing-pipeline.html) might be useful.

Some of this pipeline was documented for the [SPLADE authors](https://github.com/naver/splade/tree/main/efficient_splade_pisa). You may also be interested in checking out [Pyterrier's PISA wrapper](https://github.com/terrierteam/pyterrier_pisa) for a Python interface into PISA.
