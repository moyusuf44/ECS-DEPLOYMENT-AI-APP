# Stage 1: Build Stage

FROM python:3.11-slim AS build

WORKDIR /app

RUN pip install --no-cache-dir fastapi uvicorn openai 

# Stage 2: Runtime Stage

FROM python:3.11-slim AS runtime-stage

WORKDIR /app

COPY --from=build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=build /usr/local/bin /usr/local/bin
COPY app/ .

ENV PYTHONPATH=/usr/bin/local/lib/python3.11/site-packages

EXPOSE 8080

CMD [ "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]



