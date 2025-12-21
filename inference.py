# импортируем библиотеки для работы с файлами и изображениями 
import io
from PIL import Image
# импортируем библиотеку юльтралистик для работы с моей моделью
from ultralytics import YOLO

# создадим класс для работы с моделью и получению инференса
class ModelHandler:
    def __init__(self, model_path):
        self.model = YOLO(model_path)

    def predict(self, image_bytes):
        img = Image.open(io.BytesIO(image_bytes))

        # запустим инференс на изображения 
        results = self.model(img)

        # переформатируем детекции в формат для джейсон файла
        detections = []
        for r in results:
            for box in r.boxes:
                detections.append({
                    "box": box.xyxy[0].tolist(),  # координаты бибокса [x1, y1, x2, y2]  
                    "confidence": float(box.conf[0]),  # вероятность предсказания модели от 0.0 до 1.0
                    "class": int(box.cls[0]),  # номер класса 
                    "name": self.model.names[int(box.cls[0])]  # имя класса 
                })
        return detections
