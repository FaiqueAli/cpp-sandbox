# ---------- Stage 1: Build Dependencies ----------
    FROM python:3.12-slim AS builder

    WORKDIR /app
    
    # Copy and install dependencies
    COPY requirements.txt .
    RUN pip install --user -r requirements.txt
    
    # ---------- Stage 2: Final Minimal Image ----------
    FROM python:3.12-alpine
    
    WORKDIR /app
    
    # Copy only installed packages from builder
    COPY --from=builder /root/.local /root/.local
    
    # Copy app source code
    COPY app.py .
    
    # Update PATH to use pip binaries
    ENV PATH=/root/.local/bin:$PATH
    
    EXPOSE 5000
    
    # Start the app
    CMD ["python", "app.py"]

# # # # # # # # # # # # without multi stage # # # # # # # # # # # # # # # 
    
# FROM python:3.12-slim

# WORKDIR /app 
# COPY requirements.txt .
# RUN pip install -r requirements.txt
# COPY app.py .

# EXPOSE 5000
# CMD ["python", "app.py"]