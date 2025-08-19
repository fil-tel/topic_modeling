# Could topic modeling be a useful tool in population genetics?
(*The following description of topic modeling is my understanding of it, I have never studied it before and what I am doing here it is mainly for fun and curiosity*)

Topic modeling are unsupervised methods used in natural language processing to extract a set of abstract topics from a collection of documents.

Briefly, applying a topic modeling algorthm to a given collection of documents returns a group of abstract topics and to each document it is assigned a percentage of each topic according to the words included in the document.
For instance, if we apply a topic modeling algorithm to a collection of book synopsis, where each of the book can have a different genre, the algorithm should return a number of topics more or less equivalent to the number of genres in the collection of synopsis. It is able to do so because assumes that each topic is defined by certain words that are emitted in documents belonging to that topic with a certain probability. Moreover, a document can contain multiple topics and the same word can be emitted by different topics.  

## Why do I think it could (*maybe*) become an interesting tool in population genetics?  

In population genetics, given a sample of genomes (usually in form of SNPs) from a group of individuals, reasearchers are interested in identifying how many ancestral populations originates these genomes and how are these populations admixed. If we think about it, a population can be defined by certain specific alleles and allele frequencies. To this regard, populations can be seen as topics in a topic modeling analysis for documents, but where the words are alleles.

If what I am saying it is partly right, topic modeling in population genetics should somehow be similar to an admixture analyisis (*I guess*).

## How to I plan in checking this?

I will define some super simple models involving populations and admixture using *slendr* (https://slendr.net/) and on the genotypes extracted I will run topic modeling using *cisTopic* (https://github.com/aertslab/cisTopic).
