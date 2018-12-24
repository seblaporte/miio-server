FROM resin/rpi-raspbian:stretch

RUN [ "cross-build-start" ]

RUN apt-get update && \
    apt-get install -y python3 python3-dev python3-pip \
    libffi-dev libssl-dev \
    git && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install -U setuptools virtualenv

WORKDIR /usr/share

RUN git clone https://github.com/mrin/domoticz-mirobot-plugin.git xiaomi-mirobot && \
    cd /usr/share/xiaomi-mirobot && \
    git checkout tags/0.1.3 && \
    virtualenv -p python3 .env && \
    . /usr/share/xiaomi-mirobot/.env/bin/activate && \
    pip3 install -r pip_req.txt

RUN [ "cross-build-end" ]

EXPOSE 22222

ENTRYPOINT ["/usr/share/xiaomi-mirobot/miio_server.py", "192.168.5.29", "305467736e41477a59796f6238385933"]
CMD ["--host", "0.0.0.0", "--port", "22222"]