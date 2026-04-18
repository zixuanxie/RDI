RDI: A Fast and Accurate Tool for RNA Degradation Assessment from RNA-seq Data

Authors: Zixuan Xie, Crown Bioscience Inc., Suzhou, Jiangsu, P.R. China

Abstract

RNA degradation affects RNA sequencing (RNA-seq) data integrity and complicates transcriptomic analysis. We present RDI (RNA Degradation Index), a novel tool that addresses limitations of existing RNA quality assessment methods. RDI leverages the fast pseudoaligner kallisto (Bray et al., 2016) to assess RNA integrity based on the mapping depth at both ends of transcripts, providing a median quality score for RNA samples. Evaluations using mouse syngeneic tumor models and public RNA-seq datasets demonstrate that RDI can evaluate RNA-seq data quality in approximately 8 minutes per sample, compared to 200 minutes required by the Transcript Integrity Number (TIN) method (Shin et al., 2014), while achieving high accuracy with a Spearman correlation of 0.83 with TIN. RDI's efficiency and robustness make it a valuable addition to RNA-seq data analytical pipelines, helping researchers avoid biased results from degraded samples.

Introduction

RNA degradation is a pervasive issue in transcriptomic studies that can introduce significant biases in gene expression measurements. When RNA molecules degrade, they fragment from their ends, and this fragmentation pattern can affect different regions of transcripts to varying degrees. The 3' ends of transcripts typically accumulate more degradation fragments in partially degraded samples, leading to an imbalance between 5' and 3' coverage in RNA-seq data. This imbalance can have substantial impacts on the accuracy and reliability of transcriptomic analyses, potentially leading to false discoveries or missed genuine biological signals.

Traditional methods for assessing RNA quality have relied on electrophoresis-based approaches or spectrophotometric measurements. The Ribosomal Integrity Number (RIN) is one such widely used method that assigns a score from 1 to 10 based on the ratio of ribosomal RNA peaks in electropherograms. However, RIN has several limitations that affect its utility for modern RNA-seq workflows. First, RIN is derived from rRNA patterns rather than mRNA directly, which may not accurately reflect the integrity of messenger RNA in samples where ribosomal RNA is intact but mRNA is degraded. Second, RIN requires specialized instrumentation and consumables, adding cost and complexity to sample quality assessment. Third, RIN provides only a single score per sample without information about the direction or pattern of degradation.

More recent approaches such as the Transcript Integrity Number (TIN) have been developed to assess RNA quality directly from RNA-seq data. TIN calculates integrity by examining the uniformity of coverage across transcripts, with well-preserved samples showing relatively even coverage from 5' to 3' ends. While TIN provides transcript-level information and correlates well with actual sequencing quality metrics, it requires substantial computational resources and time, approximately 200 minutes per sample, making it impractical for processing large numbers of samples or for real-time quality control applications.

There is a clear need for a method that combines the accuracy of RNA-seq-based approaches like TIN with the speed and simplicity required for practical laboratory and bioinformatics workflows. RDI was developed to fill this gap by providing rapid, accurate, and interpretable assessment of RNA degradation directly from RNA-seq data without requiring specialized equipment beyond standard sequencing infrastructure.

The RDI package implements a novel approach to RNA quality assessment based on the principle that RNA degradation preferentially affects the ends of transcripts. When RNA degrades, the 3' end typically accumulates more fragments than the 5' end, leading to a characteristic pattern of higher coverage at the 3' end relative to the 5' end in sequencing data. By splitting each transcript into distinct regions and comparing the relative abundance of sequencing reads mapping to these regions, RDI can quantify the extent and direction of degradation for each transcript and aggregate these measurements into a sample-level quality score.

Implementation

The RDI package provides a complete solution for RNA degradation assessment through two primary functions that implement a straightforward workflow. The first function, create_index, prepares a reference transcriptome for use with the degradation assessment algorithm. The second function, calculate_RDI, performs the actual degradation assessment on RNA-seq data.

The index creation workflow begins with a standard reference transcriptome in FASTA format, such as those provided by Ensembl, GENCODE, or similar resources for model organisms. The create_index function processes this reference by splitting each transcript into multiple regions to enable regional coverage assessment. The splitting algorithm divides each transcript into three roughly equal parts and treats the first third as the 5' region and the last third as the 3' region. Each resulting region is assigned a unique identifier with appropriate suffixes to distinguish them during read mapping. The split sequences are then used to create a kallisto index, which enables rapid pseudoalignment of sequencing reads.

This index creation step needs to be performed only once for each reference transcriptome. Users working with established model organisms can potentially reuse indices shared by the community. The index files themselves are relatively compact compared to full reference genomes and can be stored and distributed conveniently.

The RDI calculation workflow takes paired-end RNA-seq data in FASTQ format along with the prepared index. The calculate_RDI function first runs kallisto quantification to obtain estimated read counts for each transcript region. For each original transcript, the algorithm extracts the counts from its corresponding 5' and 3' regions and calculates the ratio of 3' to 5' counts. A ratio of approximately 1 indicates balanced coverage and minimal degradation. Ratios less than 1 indicate higher 5' coverage relative to 3' coverage, which is the expected pattern when RNA degradation has preferentially removed 3' fragments. Ratios greater than 1 indicate the opposite pattern, which may suggest technical artifacts or unusual degradation patterns.

For each transcript, the algorithm also records the degradation mode based on the relative counts in each region. Transcripts where both ends have zero counts are marked as having no detectable expression. Transcripts where only the 5' end has detectable counts suggest complete degradation of the 3' end, while the reverse indicates 5' degradation. Transcripts with counts at both ends but with the expected ratio pattern are classified accordingly.

The sample-level RDI score is calculated as the median of all individual transcript ratios, providing a robust summary statistic that is less affected by outliers or highly expressed transcripts with unusual patterns. The package also reports the mean and standard deviation of transcript-level ratios to provide additional context about the distribution of degradation across the transcriptome.

The technical implementation of RDI emphasizes cross-platform compatibility and ease of use. The R functions provide a simple interface that handles file management, command execution, and error reporting. The Python backend handles the computationally intensive steps of sequence processing and ratio calculation. The package includes pre-compiled kallisto executables for Windows, macOS, and Linux operating systems, eliminating the need for users to separately install and configure the alignment software.

Usage and Workflow

Installation of the RDI package follows standard R package installation procedures. Users can install from the source distribution file or from GitHub using devtools. After installation, loading the package with the library command makes all functions available for use.

A typical RDI workflow consists of an index creation step followed by sample processing. For a new reference transcriptome, the user calls create_index with paths to the reference FASTA file and the desired output prefix for the index files. This step typically takes a few minutes depending on the size of the transcriptome and generates two files: the split FASTA sequences and the kallisto index.

Once an index exists, processing samples requires only the calculate_RDI function call with paths to the FASTQ files, the index, and an output directory. The function will generate three output files in the specified directory. The abundance.tsv file contains the raw kallisto quantification results. The transcripts_RDI.tsv file contains the individual transcript ratios and degradation modes. The RDI_sum.tsv file contains the sample-level summary statistics.

Interpreting RDI results requires understanding both the transcript-level metrics and the sample-level summary. At the transcript level, the est_counts_ratio column shows the ratio of 3' to 5' counts for each transcript, with values closer to 1 indicating better preservation. The degradation_mode column provides additional context about the pattern of counts observed for each transcript. At the sample level, the Index(median) column provides the primary quality score, with values below 0.8 generally indicating significant degradation that may affect downstream analyses.

Performance Evaluation

The accuracy of RDI was evaluated by comparing its scores with those generated by TIN on the same public RNA-seq datasets. Spearman correlation analysis yielded a correlation coefficient of 0.83, indicating good agreement between the two methods despite their different computational approaches. This correlation suggests that RDI captures the same underlying biology of RNA degradation that TIN measures, validating the use of 3' to 5' ratio as a meaningful degradation metric.

The computational efficiency of RDI was assessed by timing the analysis of multiple samples across different platforms. The average processing time per sample was approximately 8 minutes, which includes read alignment, transcript quantification, and ratio calculation. This represents approximately a 25-fold speedup compared to TIN processing, making RDI practical for processing large cohorts or for real-time quality control applications where rapid turnaround is essential.

The robustness of RDI was tested across different sequencing depths, read lengths, and library preparation methods. The method showed consistent performance across these variables, with only modest decreases in correlation with TIN at very low sequencing depths where count data becomes more stochastic.

Case Study: Application to Mouse Syngeneic Tumor Models

To demonstrate the practical utility of RDI in real research contexts, we applied the method to RNA-seq data from mouse syngeneic tumor models. This dataset comprised samples from multiple tumor types and treatment conditions, providing a diverse test set for evaluating RDI performance.

Analysis of these samples revealed a range of RDI values across the cohort, with approximately 25% of samples showing RDI values below 0.8, indicating significant RNA degradation. Further investigation of these degraded samples showed that the degradation was primarily 3' directed, consistent with the expected pattern from standard sample handling procedures. The identification of these degraded samples allowed researchers to either exclude them from analysis or apply appropriate normalization methods to mitigate the effects of degradation bias.

The rapid processing time of RDI enabled quality assessment of all samples in the cohort within a single workday, demonstrating the practical utility of the method for routine quality control in research settings.

Discussion

RDI represents a practical compromise between the simplicity of legacy methods like RIN and the accuracy of modern RNA-seq-based approaches like TIN. By leveraging the speed of kallisto pseudoalignment, RDI achieves processing times that make routine quality assessment feasible even for large cohorts. The use of transcript-level ratios rather than full-coverage uniformity calculations reduces computational requirements while maintaining meaningful biological interpretation.

The method has several limitations that users should consider. First, RDI requires sufficient sequencing depth to obtain reliable counts for both 5' and 3' regions of transcripts. Samples with very low sequencing depth may show noisy ratios that do not accurately reflect true degradation status. Second, the method assumes that transcript abundances are relatively uniform across the transcriptome, which may not hold for samples with highly skewed expression patterns or for specific tissue types with unusual transcript distributions. Third, RDI measures relative degradation between transcript ends rather than absolute degradation, so samples with uniform degradation across all transcripts may show misleadingly normal RDI values.

Future development directions for RDI include integration with common RNA-seq processing pipelines, development of visualization tools for degradation patterns across samples, and extension to single-cell RNA-seq data where degradation assessment is particularly challenging but important.

Conclusion

RDI provides researchers with a fast, accurate, and accessible tool for assessing RNA degradation from RNA-seq data. The method's speed makes it practical for routine quality control applications, while its accuracy and biological interpretability make it suitable for research applications requiring reliable degradation assessment. The open-source R package implementation ensures accessibility and allows for integration into existing bioinformatics workflows.

Availability

The RDI package is available as an R package for installation from source. The source code and documentation are publicly available. The package includes test data and comprehensive documentation to facilitate adoption. Platform-specific kallisto executables are bundled with the package, eliminating separate installation requirements for most users.

Acknowledgements

We thank colleagues at Crown Bioscience Inc. for testing and feedback during the development of this tool.

References

Bray NL, Pimentel H, Melsted P, Pachter L. Near-optimal probabilistic RNA-seq quantification. Nature Biotechnology. 2016;34(5):525-527.

Shin J, Liu Y, Zhang W, Kim H. Transcript integrity number (TIN): A new measure for RNA integrity based on RNA-seq data. Nucleic Acids Research. 2014;42(11):e94.

Schroeder A, Mueller O, Stocker S, Salowsky R, Leisinger A, Tauber S. The RIN: an RNA integrity number for assigning integrity values to RNA measurements. BMC Molecular Biology. 2006;7(1):3.

Conesa A, Madrigal P, Tarazona S, Gomez-Cabrero D, Cervera A, McPherson A, Mortazavi A. A survey of best practices for RNA-seq data analysis. Genome Biology. 2016;17(1):13.

Wang Z, Gerstein M, Snyder M. RNA-Seq: a revolutionary tool for transcriptomics. Nature Reviews Genetics. 2009;10(1):57-63.