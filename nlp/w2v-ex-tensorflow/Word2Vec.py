import tensorflow as tf
from tensorflow.keras import layers

''''
# Subclassed Word2Vec Model

- Using the Keras Subclassing API;
- The subclassed model enables to define the `call()` function that accepts (target, context) pairs;
- (target, context) pairs can be passed into their corresponding embedding layer;

Layers: target_embedding, context_embedding, dots, flatten.

TODO: 2021-10-06 - What is this 'flatten' thing about?
- tf.keras.layers.Flatten layer to flatten the results of dots layer into logits;
...Reshape the `context_embedding` to perform a dot product with `target_embedding` and return the flattened result.

'''
class Word2Vec(tf.keras.Model):
	
	''' Layer that looks up the embedding of a word when it appears as a target_ word; '''
	target_embedding: tf.keras.layers.Embedding = None
	
	''' Layer that looks up the embedding of a word when it appears as a context_ word; '''
	context_embedding: tf.keras.layers.Embedding = None

	def __init__(self, vocab_size: int, embedding_dim: int, num_ns: int):
		super(Word2Vec, self).__init__()
		
		self.target_embedding = layers.Embedding(
			vocab_size,		# Number of parameters: (vocab_size * embedding_dim)
			embedding_dim,
			input_length=1,
			name="w2v_embedding"
		)
		
		self.context_embedding = layers.Embedding(
			vocab_size,		# Number of parameters: (vocab_size * embedding_dim)
			embedding_dim,
			input_length= num_ns + 1
		)

	def call(self, pair: tuple) -> tf.keras.layers.Dot:
		'''
			Return the dots Layer: Computes dot product of target & context embeddings from a training pair.
		'''

		context = pair[1]	# context: (batch, context)
		target = pair[0]	# target: (batch, dummy?)  # The dummy axis doesn't exist in TF2.7+
		if len(target.shape) == 2:
			target = tf.squeeze(target, axis=1)	# target: (batch,)
		
		word_emb = self.target_embedding(target)		# (batch, embed)
		context_emb = self.context_embedding(context)	# (batch, context, embed)
		return tf.einsum('be,bce->bc', word_emb, context_emb)	# dots: (batch, context)
