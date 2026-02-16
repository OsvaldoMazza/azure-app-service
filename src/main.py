from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

# Model for /greetings endpoint
class GreetingRequest(BaseModel):
    name: str

@app.post("/greetings")
async def greetings(request: GreetingRequest):
    return {"message": f"Hello {request.name}!"}

@app.get("/movies")
async def movies():
    return {
        "movies": [
            {"title": "Titanic", "year": 1997, "type": "Drama"},
            {"title": "Rambo", "year": 1982, "type": "Action"},
            {"title": "Scarface", "year": 1983, "type": "Crime"}
        ]
    }

@app.get("/health")
async def health():
    return {"status": "ok"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)