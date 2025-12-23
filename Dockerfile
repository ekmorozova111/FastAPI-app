# заменила букворм версию питона на слим 
FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive \
    # Отключила создание .pyc файлов и буферизацию логов
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# установила системные зависимости  в одном слое с очисткой
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# установим  зависимостт (используем --no-cache-dir)
COPY requirements.txt .

# буду использовать CPU-версию PyTorch 
RUN pip install --no-cache-dir torch torchvision --index-url download.pytorch.org
RUN pip install --no-cache-dir -r requirements.txt

# копируем 
COPY . .

# Railway использует переменную PORT, динамически назначаемую сервисом
EXPOSE ${PORT}

CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-10000}"]