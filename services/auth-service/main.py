from fastapi import FastAPI
app = FastAPI()

@app.get("/health")
def health():
    return {"status": "healthy", "service": "auth-service"}

@app.get("/token")
def token():
    return {"token": "mock-jwt-token-xyz123"}
