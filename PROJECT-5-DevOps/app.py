from flask import Flask, render_template, Response
import numpy as np
import cv2 as cv
import tensorflow as tf

app = Flask(__name__, template_folder="templates")

show = ""

@app.route("/")
def index():
    return render_template("index.html")

def makePrediction(np_arr):
    np_arr = np_arr.astype('float32')
    np_arr = np_arr.reshape((1,224,224,3)) 
    # Load the TFLite model and allocate tensors.
    interpreter = tf.lite.Interpreter(model_path="model.tflite")
    interpreter.allocate_tensors()

    # Get input and output tensors.
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    # Test the model on random input data.
    input_shape = input_details[0]['shape']
    input_data = np.array(np.random.random_sample(input_shape), dtype=np.float32)
    interpreter.set_tensor(input_details[0]['index'], np_arr)

    interpreter.invoke()
    
    # The function `get_tensor()` returns a copy of the tensor data.
    # Use `tensor()` in order to get a pointer to the tensor.
    output_data = interpreter.get_tensor(output_details[0]['index'])
    labels = ["up", "down", "left", "right"]
    global show
    show = labels[np.argmax(output_data)]
    print(show)
    return

def generate_frames():
    cap = cv.VideoCapture(0)

    if not cap.isOpened():
        print("Cannot open camera")
        exit()
    while True:   
        ret, frame = cap.read()
        frame = cv.resize(frame, (224,224))
        frame = cv.flip(frame, 1)
        if not ret:
            print("Can't receive frame (stream end?). Exiting ...")
            break
    
        ret,buffer = cv.imencode('.jpg',frame)
        send_frame = buffer.tobytes()
        np_arr = np.asarray(frame)
        np_arr2 = (np_arr/127.0) - 1
        makePrediction(np_arr2)    
        yield(b'--frame\r\n'b'Content-Type: image/jpeg\r\n\r\n' + send_frame + b'\r\n')

@app.route('/predict', methods = ['post'])
def predict():
    # global show
    return render_template("predict.html")

@app.route('/getPred')
def getPred():
    global show
    print("called getPred")
    return Response(show)

@app.route('/video')
def video():
    return Response(generate_frames(),mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == "__main__":
    app.run(debug=True)