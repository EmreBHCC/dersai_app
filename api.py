from flask import Flask, request, jsonify
import requests
from PIL import Image
from io import BytesIO
import numpy as np
import base64
import traceback
import cv2
from flask_cors import CORS
from ultralytics import YOLO

app = Flask(__name__)
CORS(app, resources={r"/detect-board": {"origins": "*"}})

detect_board_model = YOLO('C:/Users/emre_/Documents/Github/YoloV11/runs/detect/train/weights/best.pt')
detect_board_model.names = {
    0: 'math',
    1: 'text',
    2: 'image',
    
}

# 🔑 Imgur API Bilgisi (gizli tutulmalı - çevre değişkeni önerilir)
IMGUR_CLIENT_ID = "Client-ID bd47c0f13c89751"

# 📤 Görseli Imgur'a yükleme
def upload_to_imgur(image_bytes):
    headers = {"Authorization": IMGUR_CLIENT_ID}
    
    data = {
        "image": base64.b64encode(image_bytes).decode("utf-8"),
        "type": "base64"
    }
    response = requests.post("https://api.imgur.com/3/image", headers=headers, data=data)
    if response.status_code == 200:
        return response.json()["data"]["link"]
    else:
        print("Imgur yükleme hatası:", response.text)
        raise Exception("Imgur yükleme başarisiz oldu")
@app.route('/detect-board', methods=['POST'])
def detect_from_url():
    try:
        data = request.get_json()
        image_url = data.get("image_url")
        print("🔗 image_url:", image_url)

        headers = {'User-Agent': 'Mozilla/5.0'}
        response = requests.get(image_url, headers=headers)
        print("🌐 Image fetch response:", response.status_code)

        if response.status_code != 200:
            return jsonify({"error": "Görsel indirilemedi.", "status": response.status_code}), 400

        # 🖼 Görseli aç ve BGR formatına çevir
        image = Image.open(BytesIO(response.content)).convert("RGB")
        img_np = np.array(image)
        img_bgr = cv2.cvtColor(img_np, cv2.COLOR_RGB2BGR)

        # 🧠 YOLO ile tespit yap
        results = detect_board_model(img_bgr)  # 🔥 Buraya dikkat!
        result = results[0]

        detections = []
        for box in result.boxes:
            cls_id = int(box.cls[0])
            conf = float(box.conf[0])
            xyxy = box.xyxy[0].tolist()
            x1, y1, x2, y2 = map(int, xyxy)

            class_name = detect_board_model.names.get(cls_id, f"class_{cls_id}")
            label = f"{class_name} {conf:.2f}"

            # 📦 Kutu ve etiket çizimi
            cv2.rectangle(img_bgr, (x1, y1), (x2, y2), (0, 255, 0), 2)
            cv2.putText(img_bgr, label, (x1, y1 - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 1)

            detections.append({
                "class_id": cls_id,
                "class_name": class_name,
                "confidence": round(conf, 2),
                "box": [round(coord, 2) for coord in xyxy]
            })

        # 📸 Encode JPG
        success, buffer = cv2.imencode(".jpg", img_bgr)
        if not success:
            return jsonify({"error": "Görsel encode edilemedi."}), 500

        # ☁ Imgur'a yükle
        imgur_url = upload_to_imgur(buffer)

        return jsonify({
            "detections": detections,
            "image_url": imgur_url
        })

    except Exception as e:
        print("❌ Hata oluştu:")
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500

# 🚀 Flask sunucu başlat
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=7000, debug=False)
