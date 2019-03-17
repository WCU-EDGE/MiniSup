# This is a Dockerfile to build a Docker image with
# Miniconda.

# We will start from a base Ubuntu 18.04
FROM ubuntu:18.04

# Create non-root user, install dependencies, install Anaconda
RUN apt-get update --fix-missing && \
    apt-get install -y build-essential tmux git gdb wget sudo && \
    useradd -m -s /bin/bash student && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O anaconda.sh && \
    mkdir -p /opt && \
    sh ./anaconda.sh -b -p /opt/conda && \
    rm anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    chown -R student /opt && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/student/.bashrc && \
    echo "conda activate base" >> /home/student/.bashrc && \
    sudo su lngo -c 'conda install -y -c anaconda jupyter' && \
    sudo su lngo -c 'jupyter notebook --generate-config' && \
    echo "c.NotebookApp.token = u''" >> /home/student/.jupyter/jupyter_notebook_config.py 

USER student
ENV PATH "/bin:/usr/bin:$PATH"
WORKDIR "/home/student"
CMD ["/bin/bash"]
