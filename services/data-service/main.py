from fastapi import FastAPI
app = FastAPI()

@app.get("/health")
def health():
    return {"status": "healthy", "service": "data-service"}

@app.get("/data")
def data():
    return {"records": [{"id": 1, "name": "Sample"}, {"id": 2, "name": "Data"}]}x
