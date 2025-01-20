from flask import Flask, request, jsonify
import cv2
import numpy as np
from keras.models import load_model # type: ignore

app = Flask(__name__)

# Load the pretrained emotion detection model
model = load_model('fer.h5')
emotions = ['Angry', 'Disgust', 'Fear', 'Happy', 'Sad', 'Surprise', 'Neutral']

@app.route('/analyze', methods=['POST'])
def analyze_emotion():
    try:
        # Decode the image from the request
        image_data = request.data
        nparr = np.frombuffer(image_data, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        
        # Preprocess the image for the model
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(48, 48))

        for (x, y, w, h) in faces:
            face = gray[y:y+h, x:x+w]
            face = cv2.resize(face, (48, 48))
            face = face / 255.0
            face = np.expand_dims(face, axis=0)
            face = np.expand_dims(face, axis=-1)

            prediction = model.predict(face)
            emotion = emotions[np.argmax(prediction)]
            return jsonify({'emotion': emotion})

        return jsonify({'emotion': 'No face detected'})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'emotion': 'Error'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
