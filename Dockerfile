# использую слим образ вместо букворм
FROM python:3.10-slim

# установлю окружение
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# установила зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# установка версии торча для процессора
RUN pip install --no-cache-dir torch torchvision \
    --index-url https://download.pytorch.org/whl/cpu

# установка требований из requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# копирую код приложения
COPY . .

# Railway использует динамический порт
EXPOSE ${PORT}

CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-10000}"]