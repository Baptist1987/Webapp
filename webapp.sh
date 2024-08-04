#!/bin/bash

# Setzen Sie den Pfad zu Ihrem Projektverzeichnis und zur Conda-Umgebung
PROJECT_DIR="/home/ubuntu/Webapp"
CONDA_ENV="base"
VENV_DIR="$PROJECT_DIR/venv"

# Funktion zum Starten der Anwendung
start() {
    echo "Starting the application..."

    # Backend starten
    source $VENV_DIR/bin/activate
    nohup uvicorn backend.main:app --host 0.0.0.0 --port 8000 &

    # Warten, damit das Backend starten kann
    sleep 5

    # Frontend starten
    nohup streamlit run $PROJECT_DIR/frontend/app.py --server.port 8501 &
    echo "Application started."
}

# Funktion zum Stoppen der Anwendung
stop() {
    echo "Stopping the application..."
    pkill -f uvicorn
    pkill -f streamlit
    echo "Application stopped."
}

# Funktion zum Neustarten der Anwendung
restart() {
    stop
    start
}

# Funktion zum Stoppen der Anwendung und Pull von GitHub
stop_and_update() {
    stop
    echo "Pulling latest changes from GitHub..."
    cd $PROJECT_DIR
    git pull origin main
    source $VENV_DIR/bin/activate
    pip install -r $PROJECT_DIR/requirements.txt
    restart
}

# Funktion zum Überprüfen des Status der Anwendung
status() {
    echo "Checking the application status..."
    UVICORN_PID=$(pgrep -f "uvicorn.*$PROJECT_DIR/backend/main:app")
    STREAMLIT_PID=$(pgrep -f "streamlit.*$PROJECT_DIR/frontend/app.py")

    if [ -n "$UVICORN_PID" ]; then
        echo "FastAPI (uvicorn) is running with PID: $UVICORN_PID"
    else
        echo "FastAPI (uvicorn) is not running."
    fi

    if [ -n "$STREAMLIT_PID" ]; then
        echo "Streamlit is running with PID: $STREAMLIT_PID"
    else
        echo "Streamlit is not running."
    fi
}

# Hauptskript zum Verarbeiten der Argumente
case "$1" in
    -s)
        start
        ;;
    -ss)
        stop
        ;;
    -r)
        restart
        ;;
    -ssu)
        stop_and_update
        ;;
    -status)
        status
        ;;
    *)
        echo "Usage: $0 {-s|-ss|-r|-ssu|-status}"
        echo "  -s      Start the application"
        echo "  -ss     Stop the application"
        echo "  -r      Restart the application"
        echo "  -ssu    Stop the application and pull updates from GitHub"
        echo "  -status Check the application status"
        exit 1
        ;;
esac
