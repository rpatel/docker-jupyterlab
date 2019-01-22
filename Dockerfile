FROM debian:stretch-slim

## Build ARGs ##
################
ARG DEBUG_BUILD
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL=https://github.com/rpatel/docker-jupyterlab
LABEL maintainer="Ravi Patel <rpatel@temple.edu>" \
      org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.name="jupyterlab" \
      org.label-schema.description=" \
        Debian Stretch (slim) based JupyterLab image. \
        For stand-alone or compose/stack service use." \
      org.label-schema.url="${VCS_URL}" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="${VCS_URL}" \
      org.label-schema.schema-version="1.0"

## Install requirements ##
##########################
RUN apt-get update \
  && apt-get install -y \
    curl \
    build-essential \
  && apt-get install -y \
    python3 \
    python2.7 \
    python3-pip \
    python-pip \
  && rm -rf /var/lib/apt/lists/*

## Make runtime user and dirs ##
################################
ARG UID=100000
ARG GID=100000
RUN groupadd -g ${GID} jupyter \
  && useradd -u ${UID} -g ${GID} -m -s /bin/bash jupyter \
  && chown -R jupyter:jupyter /home/jupyter \
  && mkdir /home/jupyter/Notebooks \
  && chown jupyter:jupyter /home/jupyter/Notebooks

USER jupyter
WORKDIR /home/jupyter

## Install jupyter notebook, widgets, and kernels ##
####################################################
RUN python3 -m pip install \
    jupyter \
    ipywidgets \
  && python -m pip install \
    ipywidgets \
  && ${HOME}/.local/bin/jupyter nbextension enable --py widgetsnbextension \
  && python3 -m pip install ipykernel \
  && python2 -m ipykernel install --user

## Install nodejs+jupyterlab and widgets ##
###########################################
ARG NVM_DIR=/home/jupyter/.nvm
ARG NODE_VERSION=lts/carbon

RUN mkdir ${NVM_DIR} \
  && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
  && . ${NVM_DIR}/nvm.sh \
  && nvm install ${NODE_VERSION} \
  && nvm alias default ${NODE_VERSION} \
  && nvm use default \
  && python3 -m pip install jupyterlab \
  && /home/jupyter/.local/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Copy utility scripts #
########################
COPY ./bin /usr/local/bin

# Entrypoint and command business #
###################################
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/home/jupyter/.local/bin/jupyter","lab"]

EXPOSE 8888
VOLUME [ "/home/jupyter/.jupyter", "/home/jupyter/Notebooks" ]
