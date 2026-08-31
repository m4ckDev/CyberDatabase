FROM python:3.12-slim
WORKDIR /app
COPY generator.py .
RUN mkdir -p /data/logs
CMD ["python", "generator.py"]
