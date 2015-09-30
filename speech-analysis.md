
# Topic modelling No.10's speeches

Computational text analysis is a rapidly growing field of research that promises to extract meaningful information from one of the most abundant and fundamentally unstructured data sources that humans produce.

Traditionally, to understand a large body of text you had to read it - getting computers to to do the reading for you is not only quicker, but can also find new patterns in the structure of the text that you wouldn't find through reading.

One such method of text analysis is **topic modelling**, which seeks to tell you what underlying topics are being discussed in a collection of texts. In this context, a topic is just a collection of words that are related - for example, the words *car*, *train*, *boat* and *plane* could all be members of a topic called "*transport*". Similarly, you could have another topic, "*exercise*", that contains the words *run*, *marathon* and *train*. Notice that the word *train* appears in both topics: this is a feature of topic modeling - it allows terms to be included in multiple topics.

The algorithm I'll demonstrate here is something called *Latent Dirichlet Allocation*. It works by looking at a collection of documents, and searching for terms that co-occur frequently. So, if the terms *cat* and *dog* appeared together in multiple documents, but rarely appeared on their own, the algorithm would identoify this and group them in to a topic.

A key feature of the algorithm is that it requires no information on the collection of documents being studied - it simply looks at the distribution of terms and groups them together in to as many topics as you specify up front. The output is then a list of terms for each topic, but with no labels - the algorithm doesn't know what a topic should be called, as it doesn't really care about the actual words used!

To demonstrate, I've downloaded all of the official speeches published by No.10 during the coalition years (2010-2015) from data.gov (I used import.io for the data retrieval). There are over 400 speeches, covering a huge range of topics, and often multiple topics are discussed within a single speech.

Below is a visualisation of the output of a 28 topic model run on the speeches. Before going any further, first set the slider at the top right of the visualisation to 0.6. This
