from flask import Flask, request, jsonify
from tensorflow.python.ops.gen_math_ops import imag
import werkzeug
import os
from tensorflow import keras
import os
from tensorflow.keras.applications import VGG19
from tensorflow.keras.layers import Input, Dense, Flatten, Lambda, Dropout
from tensorflow.keras.preprocessing.image import ImageDataGenerator, load_img
from tensorflow.keras.models import Model, Sequential
import numpy as np
from tensorflow.keras.applications.imagenet_utils import preprocess_input, decode_predictions
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import os
from bs4 import BeautifulSoup
import requests
from requests_html import HTMLSession


app = Flask(__name__)



@app.route('/upload', methods=["POST"])
def upload():
    if request.method == "POST" :
        imagefile = request.files['image']
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        directory = os.path.dirname(os.path.abspath(__file__))
        print("\nReceived image File name : " + imagefile.filename)
        imagefile.save(directory+"\\"+filename)
        print(str(filename))
       
        
        #Load model and do prediction
        model = load_model('Veganizer_model.h5')
        
        def predictions (img_path):
            img = image.load_img(img_path, target_size=(224,224))
            
            x = image.img_to_array(img)
            # Network benötigt 4 Dimensionen -> neue 1. Dimension wird hinzugefügt (sample Dimension) (2.=rows, 3.=columns, 4.=channels)
            x = np.expand_dims(x, axis=0)
            
            preds = model.predict(x)
            return(preds, img)
            
        result, img = predictions(str(filename))
       

        label_names = ['Burger', 'Gulasch', 'Pasta', 'Pizza']
        pred_labels = np.argmax(result, axis=-1)
        #print(type(pred_labels))
        #print(label_names[pred_labels[0]])


        # Variablen mit gesuchtes Gericht als String
        dish_searched = label_names[pred_labels[0]]
        
        #find the URL on VeganHecaven
        URL = "https://veganheaven.de/?s=" + dish_searched

        page1 = requests.get(URL)
        data = page1.text

        soup = BeautifulSoup(data,features="lxml")

        results = soup.find_all('a', attrs={'class': 'entry-image-link'})
        #in Klammern -> Nummer des Gerichts auf Übersichtsseite
        URL_toScrape = results[2]['href']

        return jsonify({
            "browserUrl": URL_toScrape 
        })
        

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

