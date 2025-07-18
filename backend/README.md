# FastAPI Backend - Project Setup and Usage Guide

A comprehensive guide for setting up and running your FastAPI backend application.

## 📋 Prerequisites

- Python 3.8 or higher
- pip package manager

## 🚀 Getting Started

### 1. Create a Virtual Environment

It is recommended to create a Python virtual environment to manage dependencies separately:

```bash
python -m venv venv
```

### 2. Activate the Virtual Environment

**Windows (PowerShell):**
```powershell
.\venv\Scripts\Activate.ps1
```

**Windows (Command Prompt):**
```cmd
.\venv\Scripts\activate.bat
```

**macOS/Linux:**
```bash
source venv/bin/activate
```

### 3. Install Dependencies

Install all required packages from the `requirements.txt` file:

```bash
pip install -r requirements.txt
```

### 4. Initialize and Run the Server

Start the FastAPI server using Uvicorn:

```bash
uvicorn main:app --reload
```

**Parameters:**
- `main` - The Python file where your FastAPI app is defined
- `app` - The FastAPI instance variable
- `--reload` - Enables auto-reload on code changes during development

Your server will be available at: `http://127.0.0.1:8000`

## 📁 Project Structure

```
project-root/
├── api/              # API endpoint route definitions
├── services/         # Business logic and data handling
├── main.py          # FastAPI application entry point
├── requirements.txt # Project dependencies
└── README.md       # This file
```

### Directory Descriptions

- **`api/`** - Contains endpoint route definitions. Add or update API route handlers here to define the HTTP interface.
- **`services/`** - Contains service functions that handle core business logic and interact with data sources or external systems. Keep your API routes thin by delegating heavy logic to services.

## 📚 API Documentation

FastAPI automatically generates interactive API documentation using Swagger UI.

### Access Documentation

Once the server is running, navigate to:

```
http://127.0.0.1:8000/docs
```

### Features

The Swagger UI allows you to:
- ✅ Explore all API endpoints
- ✅ Send test requests directly from the browser
- ✅ View detailed request/response schemas
- ✅ Check HTTP status codes and error responses

### Alternative Documentation

ReDoc documentation is also available at:
```
http://127.0.0.1:8000/redoc
```

## 🔧 Development

### Updating Dependencies

After installing or updating packages during development, update your `requirements.txt`:

```bash
pip freeze > requirements.txt
```

### Running in Production

For production deployments, consider using:

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

### Environment Variables

Consider using environment variables for configuration:
- Database URLs
- API keys
- Debug flags
- Port numbers

## 📝 Common Commands

| Command | Description |
|---------|-------------|
| `uvicorn main:app --reload` | Start development server |
| `pip install -r requirements.txt` | Install dependencies |
| `pip freeze > requirements.txt` | Update requirements file |
| `deactivate` | Exit virtual environment |

---

**Happy coding!** 🎉