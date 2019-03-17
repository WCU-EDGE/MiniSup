# This is a Dockerfile to build a Docker image for
# Operating Systems.

# We will start from a base Ubuntu 18.04
FROM ubuntu:18.04

# Create non-root user, install dependencies, install Anaconda
RUN apt-get update --fix-missing && \
    apt-get install -y build-essential tmux git gdb wget && \    
    git clone https://github.com/longld/peda.git /root/ && \
    echo "source /root/peda/peda.py" >> /root/.gdbinit && \

RUN apt-get install -y nano
RUN apt-get install -y qemu

RUN git clone https://github.com/linhbngo/xv6-public.git /root/xv6 && \
    echo "add-auto-load-safe-path /root/xv6/.gdbinit" >> /root/.gdbinit

ENV PATH "/bin:/usr/bin:$PATH"
WORKDIR "/root"
CMD ["/bin/bash"]
