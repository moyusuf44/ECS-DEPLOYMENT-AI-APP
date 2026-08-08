from fastapi import FastAPI 
from pydantic import BaseModel
from openai import OpenAI 
from dotenv import load_dotenv
import os 

load_dotenv()

app = FastAPI()

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


conversations = {}

class ChatRequest(BaseModel):
    user_id : str
    message : str 

@app.get("/")
def root():
    return {"status" : "running"}

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/ask")
def ask_ai(question: str):
    response = client.chat.completions.create(
        model    = "gpt-4o-mini",
        messages = [
            {"role": "user", "content": question }
        ],
        max_tokens = 200
    )
    return {
        "answer": response.choices[0].message.content
    }

@app.post("/chat")
def chat(req: ChatRequest):
    MAX_HISTORY = 10
    MAX_TOKENS  = 200

    if req.user_id not in conversations:
        conversations[req.user_id] = [
            {"role": "system", "content": "You're a helpful AI assistant"}
        ]

    conversations[req.user_id].append({
        "role"    : "user", 
        "content" : req.message
    })   

    conversations[req.user_id] = (
        [conversations[req.user_id][0]] +
         conversations[req.user_id][-MAX_HISTORY:]
    )
    

    response = client.chat.completions.create(
        model      = "gpt-4o-mini",
        messages   = conversations[req.user_id]
        max_tokens = MAX_TOKENS
    )

    reply = response.choices[0].message.content

    conversations[req.user_id].append({
        "role"    : "assistant",
        "content" : reply
    })

    return {
        "reply" : reply
    }