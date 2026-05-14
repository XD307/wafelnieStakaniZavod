from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Разрешаем запросы с фронтенда
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"message": "Завод вафельных стаканчиков работает"}

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/products")
def get_products():
    return {"products": ["вафельный стаканчик маленький", "вафельный стаканчик большой"]}