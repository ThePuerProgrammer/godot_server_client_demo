# godot_server_client_demo
First, ensure that Godot is installed on your system

1) Clone this repo into your godot projects folder
2) Open a powershell, cd into the exports folder in the project tree. Create a localhost server with python 
    `python -m http.server`
3) In the Godot editor, load the test project and run it with the play button in the upper right
4) In the running demo select the server button. You should see `Number of clients connected: 0`
5) Open a browser and go to 
    `localhost:8000`
6) Select client, observe the result in the running executables, and repeat with multiple running tabs
