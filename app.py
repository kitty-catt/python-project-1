from flask import Flask, jsonify, request
app = Flask(__name__)

@app.route('my_awesome_api', methods=['POST'])
def my_awesome_endpoint():
    data = request.json
    return jsonify(data=data, meta={"status": "ok"})

app.run()