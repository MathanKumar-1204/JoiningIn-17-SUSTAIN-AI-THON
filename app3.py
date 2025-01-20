from flask import Flask, request, jsonify
from flask_cors import CORS  # Import CORS
import joblib
import pandas as pd

from groq import Groq

# Initialize the Groq client
client = Groq(
    api_key=""
)

# Set up the Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Set up the conversation history
conversation_history = [
    {
        "role": "system",
        "content": "You are a conversational AI chatbot for real-time support and guidance. The chatbot should respond immediately with short, helpful messages."
    }
]

def ask(user_input):
    conversation_history.append({
        "role": "user",
        "content": user_input
    })
    
    try:
        chat_completion = client.chat.completions.create(
            messages=conversation_history,
            model="llama3-70b-8192",
            temperature=0.5,
            max_tokens=1024,
            top_p=1,
            stop=None,
            stream=False,
        )

        response = chat_completion.choices[0].message.content
        conversation_history.append({
            "role": "assistant",
            "content": response
        })

        print("Groq API Response:", response)  # Debugging step
        return response

    except Exception as e:
        print(f"Error calling Groq API: {str(e)}")
        return "Sorry, I encountered an error."

@app.route('/get_stat', methods=['POST'])
def get_stat():
    try:
        # Load the trained models
        model_stress = joblib.load('/path_to_models/stress_model.pkl')
        model_anxiety = joblib.load('/path_to_models/anxiety_model.pkl')
        model_depression = joblib.load('/path_to_models/depression_model.pkl')

        # Load the label encoders
        label_encoder_stress = joblib.load('/path_to_models/label_encoder_stress.pkl')
        label_encoder_anxiety = joblib.load('/path_to_models/label_encoder_anxiety.pkl')
        label_encoder_depression = joblib.load('/path_to_models/label_encoder_depression.pkl')

        # Parse input data
        data = request.json
        custom_data_list = data.get('stats', [])
        if not custom_data_list:
            return jsonify({"error": "No data provided"}), 400

        # Create DataFrame from custom data
        custom_data = pd.DataFrame(custom_data_list)

        # Make predictions
        stress_pred = model_stress.predict(custom_data)
        anxiety_pred = model_anxiety.predict(custom_data)
        depression_pred = model_depression.predict(custom_data)

        # Decode the predictions
        stress_pred_label = label_encoder_stress.inverse_transform(stress_pred)[0]
        anxiety_pred_label = label_encoder_anxiety.inverse_transform(anxiety_pred)[0]
        depression_pred_label = label_encoder_depression.inverse_transform(depression_pred)[0]

        # Return the results
        result = {
            "Stress Prediction": stress_pred_label,
            "Anxiety Prediction": anxiety_pred_label,
            "Depression Prediction": depression_pred_label
        }

        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/get_answer', methods=['POST'])
def get_answer():
    data = request.json
    user_message = data.get('question', '')
    
    print("User question received:", user_message)  # Debugging step
    
    # Use the Groq-based AI model to get a response
    ai_response = ask(user_message)
    
    print("AI Response to be sent:", ai_response)  # Debugging step
    
    return jsonify({'answer': ai_response})

@app.route('/submit', methods=['POST'])
def submit():
    data = request.get_json()
    answers = data['answers']

    # Define answer mapping and threshold for "depressed"
    answer_map = {
        'Never': 0,
        'Rarely': 1,
        'Sometimes': 2,
        'Often': 3,
        'Always': 4
    }

    # Convert the answers to numerical values
    scores = [answer_map[answer] for answer in answers]

    # Simple rule: if the total score exceeds a threshold, classify as "depressed"
    threshold = 40  # You can adjust this threshold
    total_score = sum(scores)

    if total_score > threshold:
        result = "You are depressed"
    else:
        result = "You are fine "

    return jsonify({"prediction": result})

if __name__ == '__main__':
    app.run(port=5000)
