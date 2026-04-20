from fastapi import FastAPI
app = FastAPI()

@app.get("/health")
def health():
    return {"status": "healthy", "service": "api-gateway"}

@app.get("/")
def root():
    return {"message": "API Gateway running"}
