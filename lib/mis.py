import tensorflow as tf

# Load your saved model
model = tf.saved_model.load('C:\\Users\\Mathan\\Desktop\\emote\\fer.h5')

# Convert the model to TensorFlow Lite format
converter = tf.lite.TFLiteConverter.from_saved_model('C:\\Users\\Mathan\\Desktop\\emote\\fer.h5')
tflite_model = converter.convert()

# Save the converted model
with open('emotion_model.tflite', 'wb') as f:
    f.write(tflite_model)