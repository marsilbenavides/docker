docker run -d\
    --name open-terminal\
    --restart unless-stopped\
    --publish 8000:8000\
    --volume /home/marsilbenavides/open-terminal-volume:/home/user\
    --env OPEN_TERMINAL_API_KEY=QnF5Ei_IJxI6aBEVSp02ay3Al-_BiZgJP8j-osthOCY\
    ghcr.io/open-webui/open-terminal:slim

