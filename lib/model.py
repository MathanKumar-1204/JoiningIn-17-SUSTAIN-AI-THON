import requests
from time import sleep

model_url = "https://github.com/oarriaga/face_classification/raw/master/trained_models/emotion_models/fer2013_mini_XCEPTION.102-0.66.hdf5"
model_path = "fer.h5"

def download_model(url, path, retries=3):
    for attempt in range(retries):
        try:
            print(f"Attempt {attempt + 1} to download the model...")
            response = requests.get(url, stream=True, timeout=10)
            response.raise_for_status()
            with open(path, "wb") as file:
                for chunk in response.iter_content(chunk_size=8192):
                    file.write(chunk)
            print("Model downloaded successfully!")
            return
        except requests.exceptions.RequestException as e:
            print(f"Download failed: {e}")
            if attempt < retries - 1:
                sleep(2 ** attempt)  # Exponential backoff
            else:
                print("Exceeded maximum retries.")
                raise

download_model(model_url, model_path)
