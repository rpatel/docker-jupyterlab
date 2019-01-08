# JupyterLab with Python 2 and 3 Kernels for Docker

[![Docker Automated Build](https://img.shields.io/docker/automated/patelravip/jupyterlab.svg)](https://hub.docker.com/r/patelravip/jupyterlab)
[![Docker Build Status](https://img.shields.io/docker/build/patelravip/jupyterlab.svg)](https://hub.docker.com/r/patelravip/jupyterlab)
[![Docker Stars](https://img.shields.io/docker/stars/patelravip/jupyterlab.svg)](https://hub.docker.com/r/patelravip/jupyterlab)
[![Docker Pulls](https://img.shields.io/docker/pulls/patelravip/jupyterlab.svg)](https://hub.docker.com/r/patelravip/jupyterlab)
[![Image Layers](https://images.microbadger.com/badges/image/patelravip/jupyterlab.svg)](https://microbadger.com/images/patelravip/jupyterlab)
[![Build from Commit](https://images.microbadger.com/badges/commit/patelravip/jupyterlab.svg)](https://microbadger.com/images/patelravip/jupyterlab)
![Analytics](https://analytics.ravipatel.org/p?idsite=4&rec=1)

Docker image for a JupyterLab instance that includes Python 2 and 3 kernels as 
well as associated packages required for notebook widgets.

#### Relevant links
* GitHub @ [rpatel/docker-jupyterlab](https://github.com/rpatel/docker-jupyterlab/)
* Docker Registry @ [patelravip/jupyterlab](https://hub.docker.com/r/patelravip/jupyterlab/)
* JupyterLab @ [JupyterLab Documentation](https://jupyterlab.readthedocs.io/en/stable/)

## Quickstart

### Fetch the image
* Pull the latest automated build using the docker pull command: `docker pull patelravip/jupyterlab` OR clone the repository and build a local image: `docker build -t my-jupyter-image`

### Collect your requirements 
* Make text files with python requirements that will be installed by `pip` on start:
  
  e.g., `my_python2_requirements.txt` and/or `my_python3_requirements.txt`:

      requests
      bs4

      numpy
      scipy
      pandas
      matplotlib

      stevedore>=1.3.0,<1.4.0
  following `pip` [requirments file format](https://pip.pypa.io/en/stable/reference/pip_install/#requirements-file-format).

  _*Note*: requirements can be installed from inside JupyterLab as well;
  this is just for set-and-forget convenience when moving JupyterLab setups
  around._

### Generate basic notebook configuration file
* Run `jlab_genconfig` command to generate initial configuration file if you
  do not already have one. 

      $ touch /path/to/my/new/config/file/jupyter_notebook_config.py

      $ sudo chown :100000 /path/to/my/new/config/file/jupyter_notebook_config.py

      $ chmod g+rw /path/to/my/new/config/file/jupyter_notebook_config.py

      $ docker run --rm --log-driver=none -ti \
          -v "/path/to/my/new/config/file/jupyter_notebook_config.py:/home/jupyter/.jupyter/jupyter_notebook_config.py" \
          patelravip/jupyterlab jlab_genconfig
      
  If you do not have `sudo` permissions, you can expose the file to all other users
  instead of `sudo chown ...` above:

      $ chmod o+rw /path/to/my/new/config/file/jupyter_notebook_config.py

### Make a directory to store notebooks
* Make a directory for Notebooks that is writable by a UID/GID 100000 
(`jupyterlab` user in container):

      $ mkdir /path/to/my/notebooks/directory

      $ sudo chown :100000 /path/to/my/notebooks/directory

      $ chmod g+rw /path/to/my/notebooks/directory

  If you do not have `sudo` permissions, you can expose the directory to all 
  other users instead of `sudo chown` above:
  
      $ chmod o+rw /path/to/my/notebooks/directory

### Finally,
* Start JupyterLab on Port 8888:

      $ docker run --log-driver=none \
          -v "/path/to/my_python2_requirements.txt:/requirements.py2.txt" \
          -v "/path/to/my_python3_requirements.txt:/requirements.py3.txt" \
          -v "/path/to/my/new/config/file/jupyter_notebook_config.py:/home/jupyter/.jupyter/jupyter_notebook_config.py" \
          -v "/path/to/my/notebooks/directory:/home/jupyter/Notebooks \
          -p "8888:8888" \
          patelravip/jupyterlab
  
  Modify the volumes, `-v`, according to your requirement files, config file, and 
  Notebooks directory.


  You should be able to access JupyterLab from your browser at the following address:
  [http://localhost:8888/](http://localhost:8888). The token for login will be provided
  in the log messages in the terminal after executing the command above.