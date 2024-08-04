import streamlit as st
import requests
import os

backend_url = os.getenv("BACKEND_URL", "http://127.0.0.1:8000")


def register_user(username, email, name, password):
    response = requests.post(f"{backend_url}/register",
                             json={"username": username, "email": email, "name": name, "password": password})
    return response.json()


def login_user(username, password):
    response = requests.post(f"{backend_url}/login", json={"username": username, "password": password})
    return response.json()


def generate_api_key(username):
    response = requests.post(f"{backend_url}/api/keys", json={"username": username})
    return response.json()


def get_api_keys():
    response = requests.get(f"{backend_url}/api/keys")
    return response.json()


def show_login_page():
    st.title("Login")

    username = st.text_input("Username")
    password = st.text_input("Password", type="password")

    if st.button("Login"):
        result = login_user(username, password)
        if "api_key" in result:
            st.session_state.api_key = result["api_key"]
            st.session_state.username = username
            st.session_state.logged_in = True
            st.success("Login successful")
        else:
            st.error("Invalid username or password")


def show_register_page():
    st.title("Register")

    username = st.text_input("Username")
    email = st.text_input("Email")
    name = st.text_input("Name")
    password = st.text_input("Password", type="password")

    if st.button("Register"):
        result = register_user(username, email, name, password)
        if "api_key" in result:
            st.success("User registered successfully")
        else:
            st.error(result.get("detail", "Registration failed"))


def show_main_page():
    st.title("Main Page")
    st.write(f"Welcome, {st.session_state.username}!")

    tabs = st.tabs(["Home", "Profile", "Settings"])

    with tabs[0]:
        st.write("Home content")

    with tabs[1]:
        st.write("Profile content")

    with tabs[2]:
        st.write("Settings content")

    if st.button("Logout"):
        st.session_state.logged_in = False
        st.session_state.username = None
        st.session_state.api_key = None


# Hauptlogik
if "logged_in" not in st.session_state:
    st.session_state.logged_in = False

if st.session_state.logged_in:
    show_main_page()
else:
    page = st.sidebar.selectbox("Select a page", ["Login", "Register"])

    if page == "Login":
        show_login_page()
    elif page == "Register":
        show_register_page()
