# Подгружаем легкий образ питона котрый требует мало памяти 
FROM python:3.10-bookworm

# Используем не интеректативный образ Линукса
ENV DEBIAN_FRONTEND=noninteractive

# Установим рабочую директорию 
WORKDIR /app

# Установим зависимости для Оупен сиви и Йоло 
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Возьмем список библиотек из файла requirements и установим 
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Сделаем копию кода и модели 
COPY . .

# Сделаем порт для рендора 
EXPOSE 10000

# Запустим приложение при помощи  Uvicorn
# У рендера дефолтный порт 10000
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-10000}"]
