# заменила букворм версию питона на слим и начала первый этап
FROM python:3.10-slim AS builder

WORKDIR /app

# устанавливаю зависимости
RUN apt-get update && apt-get install -y --no-install-recommends gcc python3-dev && rm -rf /var/lib/apt/lists/*

# установка torch только для процессора
RUN pip install --no-cache-dir --user torch torchvision  \
    --index-url download.pytorch.org

# установка требований
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# второй этап сборки
FROM python:3.10-slim

WORKDIR /app

# установка только самых необходимых зависимостей
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# копирование установленных библиотек из первого этапа
COPY --from=builder /root/.local /root/.local
COPY . .

# добавление пути к установленным пакетам в PATH
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

EXPOSE ${PORT}

CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-10000}"]