# заменила букворм версию питона на слим 
FROM python:3.10-slim

# делаем окружение из очень легкого линукса 
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
WORKDIR /app

# устанавливаем зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# устанавливаем легкий torch для процессора
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir torch torchvision \
    --extra-index-url download.pytorch.org

# копируем requirements.txt
COPY requirements.txt .

# устанавливаем остальные библиотеки
RUN pip install --no-cache-dir -r requirements.txt

# копируем проект
COPY . .

EXPOSE ${PORT}

CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-10000}"]