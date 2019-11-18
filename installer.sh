#!/usr/bin/env bash

if [ "$1" != "" ]; then
    echo "Environment name will be $1"
    env=$1
else
    echo "Positional parameter 1 is empty"
    env="piret_env"
fi


set -e # Exit as soon as any line in the bash script fails

ROOTDIR=$( cd $(dirname $0) ; pwd -P ) # path to main PiReT directory


echo
exec &> >(tee -a  install.log)
exec 2>&1 # copies stderr onto stdout

conda create -n $env python=3.6.6 --yes
conda install -c bioconda faqcs -n $env --yes
conda install -c bioconda star hisat2 subread -n $env --yes
conda install -c bioconda subread stringtie -n $env --yes
conda install -c bioconda samtools bamtools bedtools -n $env --yes
conda install -c bioconda diamond=0.9.24 -n $env --yes
conda install -c bioconda perl-lwp-protocol-https -n $env --yes
conda install -c bioconda perl-json -n $env --yes
source ~/.bashrc
source activate $env
cd thirdparty
rm -rf eggnog-mapper
git clone https://github.com/mshakya/eggnog-mapper.git
cd eggnog-mapper
python download_eggnog_data.py -y
cd ..
cd ..
Rscript --no-init-file -e "if('BiocManager' %in% rownames(installed.packages()) == FALSE){install.packages('BiocManager',repos='https://cran.r-project.org')}";

Rscript --no-init-file -e "if('optparse' %in% rownames(installed.packages()) == TRUE){packageVersion('optparse');}"  | awk '{print " - found optparse "$2}'
Rscript --no-init-file -e "if('optparse' %in% rownames(installed.packages()) == FALSE){install.packages('optparse',repos='https://cran.r-project.org')}";
# install tidyverse
Rscript --no-init-file -e "if('tidyverse' %in% rownames(installed.packages()) == TRUE){packageVersion('tidyverse');}"  | awk '{print " - found tidyverse "$2}'
Rscript --no-init-file -e "if('tidyverse' %in% rownames(installed.packages()) == FALSE){install.packages('tidyverse',repos='https://cran.r-project.org')}";
# install R reshape2 packages
Rscript --no-init-file -e "if('reshape2' %in% rownames(installed.packages()) == TRUE){packageVersion('reshape2');}"  | awk '{print " - found reshape2 "$2}'
Rscript --no-init-file -e "if('reshape2' %in% rownames(installed.packages()) == FALSE){install.packages('reshape2',repos='https://cran.r-project.org')}";
# install R pheatmap packages
Rscript --no-init-file -e "if('pheatmap' %in% rownames(installed.packages()) == TRUE){packageVersion('pheatmap');}"  | awk '{print " - found pheatmap "$2}'
Rscript --no-init-file -e "if('pheatmap' %in% rownames(installed.packages()) == FALSE){install.packages('pheatmap',repos='https://cran.r-project.org')}";
# install R edgeR packages
Rscript --no-init-file -e "if('edgeR' %in% rownames(installed.packages()) == TRUE){packageVersion('edgeR');}"  | awk '{print " - found edgeR "$2}'
Rscript --no-init-file -e "if('edgeR' %in% rownames(installed.packages()) == FALSE){BiocManager::install('edgeR')}";
# install R deseq2 packages
Rscript --no-init-file -e "if('DESeq2' %in% rownames(installed.packages()) == TRUE){packageVersion('DESeq2');}"  | awk '{print " - found DESeq2 "$2}'
Rscript --no-init-file -e "if('DESeq2' %in% rownames(installed.packages()) == FALSE){BiocManager::install('DESeq2')}";
# install R pathview package
Rscript --no-init-file -e "if('pathview' %in% rownames(installed.packages()) == TRUE){packageVersion('pathview');}"  | awk '{print " - found pathview "$2}'
Rscript --no-init-file -e "if('pathview' %in% rownames(installed.packages()) == FALSE){BiocManager::install('pathview')}";

# install R gage package
Rscript --no-init-file -e "if('gage' %in% rownames(installed.packages()) == TRUE){packageVersion('gage');}"  | awk '{print " - found gage "$2}'
Rscript --no-init-file -e "if('gage' %in% rownames(installed.packages()) == FALSE){BiocManager::install('gage')}";
# install R ballgown package
Rscript --no-init-file -e "if('ballgown' %in% rownames(installed.packages()) == TRUE){packageVersion('ballgown');}"  | awk '{print " - found ballgown "$2}'
Rscript --no-init-file -e "if('ballgown' %in% rownames(installed.packages()) == FALSE){BiocManager::install('ballgown')}";
python setup.py install




echo "
All done!
Run
source activate $env
piret -h
for usage.
Read the README for more information!
	"