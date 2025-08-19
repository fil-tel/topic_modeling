# Can topic modeling be a useful tool in population genetics?
(*The following description of topic modeling is my understanding of it, I have never studied it before and what I am doing here it is mainly for fun and curiosity*)

Topic modeling are unsupervised methods used in natural language processing to extract a set of abstract topics from a collection of documents.

Briefly, applying a topic modeling algorthm to a given collection of documents returns a group of abstract topics and to each document it is assigned a percentage of each topic according to the words included in the document.
For instance, if we apply a topic modeling algorithm to a collection of book synopsis, where each of the book can have a different genre, the algorithm should return a number of topics more or less equivalent to the number of genres in the collection of synopsis. It is able to do so because assumes that each topic is defined by certain words that are emitted in documents belonging to that topic with a certain probability. Moreover, a document can contain multiple topics and the same word can be emitted by different topics.  
