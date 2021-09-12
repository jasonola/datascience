import os
from flask import Flask, render_template
from flask import Flask, flash, request, redirect, url_for
from werkzeug.utils import secure_filename
import pickle
import matplotlib.pyplot as plot
import numpy as np
from pyAudioAnalysis import MidTermFeatures as aF
from pyAudioAnalysis import audioBasicIO as aIO 
import IPython
import scipy.io.wavfile as wavfile
from sklearn.preprocessing import PowerTransformer
import pandas as pd
import shutil




####################################################
### Define constant variables 
####################################################

modelLG = pickle.load(open("models/model_test.sav","rb"))
modelKNN = pickle.load(open("models/model_test_knn.sav","rb"))
modelRF = pickle.load(open("models/model_test_tree.sav","rb"))
modelSVM = pickle.load(open("models/svm.sav","rb"))





####################################################
### Lauch Flask and app settings
####################################################

app = Flask(__name__)




####################################################
### Flask routes and algorithm
####################################################

@app.route('/')
def index():
    """Load the homepage"""
    return render_template('index.html')

@app.route('/', methods=['POST'])
def upload_file():
    """Main function that gets form infos, extract values from .wav and send result"""

    if request.method == 'POST':

        ###################################################
        ### Load file and get infos
        ###################################################

        # Make sure that uploads + static/images folders are empty 
        folders = ['uploads', 'static/images']
        for folder in folders:
            for f in os.listdir(folder):
                file_path = os.path.join(folder, f)
                try:
                    if os.path.isfile(file_path) or os.path.islink(file_path):
                        os.unlink(file_path)
                    elif os.path.isdir(file_path):
                        shutil.rmtree(file_path)
                except Exception as e:
                    print('Failed to delete %s. Reason: %s' % (file_path, e))


        # Get informations from form: file and choosen model
        model = request.form.get("model")
        spec_checkbox = request.form.get("spectrogram")
        chroma_checkbox = request.form.get("chroma")
        tempo_checkbox = request.form.get("tempo")
        uploaded_file = request.files['file']
        filename = uploaded_file.filename

        # If a file is selected, save it to uploads folder
        if filename == '':
            return 'No file selected'
        else:
            uploaded_file.save(secure_filename(filename))
            track_path = "uploads/" + str(filename)
            shutil.move(filename, track_path)
            print(str(filename) + " has been downloaded and the chosen model is " + str(model))



        ###################################################
        ### TODO: Compute visuals
        ###################################################

        if spec_checkbox:
            print("Spectogram checkbox checked")

        if chroma_checkbox:
                    print("Chroma spectrogram checkbox checked")
        
        if tempo_checkbox:
                    print("Tempogram checkbox checked")


        visuals = os.listdir('static/images/')


        ###################################################
        ### MGR
        ###################################################

        # Extract features and remove file from upload folder
        features = extract()
        os.remove(track_path)

        # Call funciton according to user choice
        if model == 'logreg':
            result_list = logreg(features[0], features[1])
        elif model == 'knn':
            result_list = knn(features[0], features[1])
        elif model == 'randomforest':
            result_list = randomforest(features[0], features[1])
        elif model == 'svm':
            result_list = svm(features[0], features[1])

        text = "Your file " + str(result_list[0]) + "\'s predicted genre is <b style=\"color:red;\">" + str(result_list[1]) + "</b> with the model " + str(result_list[2]) + "!"
        return render_template("results.html", text = text)

@app.route('/result', methods=['POST'])
def results():
    """Load the result page""" 

    return render_template('results.html')

if __name__ == "__main__":
    app.run(debug=True)









####################################################
### Function that gets features from input file
####################################################

def extract():
    '''Function that extract features from uploaded file''' 

     # Load the power transformer we used in prep
    pt = pickle.load(open("powertransformer.sav","rb"))

    # put the same values from extract feature notebook in function variable
    m_win, m_step, s_win, s_step = 1, 1, 0.1, 0.05 
    
    # Extract features form files in dir uploads
    features, files, feature_names = aF.directory_feature_extraction("uploads/",m_win,m_step, s_win,s_step,compute_beat=False)

    features_pt = pt.transform([features])  
    extract_results = [features_pt, files]
    return extract_results









####################################################
### Predicting models
####################################################

def logreg(features_pt, files):
    # Predict - returns a list: [filename, predicted genre, model]
    for i in range(len(features_pt)):
        sample = pd.DataFrame(pd.DataFrame(features_pt[i])).T
        results = [files[i], modelLG.predict(sample)[0], "logistic regression"]
        return results

def knn(features_pt, files):
    ## Predict - returns a list: [filename, predicted genre, model]
    for i in range(len(features_pt)):
        sample = pd.DataFrame(pd.DataFrame(features_pt[i])).T
        results = [files[i], modelKNN.predict(sample)[0], "k-nearest neighbors"]
        return results

def randomforest(features_pt, files):
    # Predict - returns a list: [filename, predicted genre, model]
    for i in range(len(features_pt)):
        sample = pd.DataFrame(pd.DataFrame(features_pt[i])).T
        results = [files[i], modelRF.predict(sample)[0], "random forest"]
        return results
    
def svm(features_pt,files):
    # Predict - returns a list: [filename, predicted genre, model]
    for i in range(len(features_pt)):
        sample = pd.DataFrame(pd.DataFrame(features_pt[i])).T
        results = [files[i], modelSVM.predict(sample)[0], "kernel SVM"]
        return results

