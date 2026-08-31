FROM python:3.12-slim
WORKDIR /app
COPY monitor.py .
RUN mkdir -p /data/reports
CMD ["python", "monitor.py"]
