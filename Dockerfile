
# set up some variables
ARG IMAGE=airflow
ARG TAG=2.1.2
ARG STAGEPATH=/tmp/airflow

# builder stage
FROM bitnami/$IMAGE:$TAG as builder

# refresh the arg
ARG STAGEPATH

# user root is required for installing packages
USER root

# install build essentials
RUN install_packages build-essential unixodbc-dev curl gnupg2
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# make paths, including apt archives or the download-only fails trying to cleanup
RUN mkdir -p $STAGEPATH/deb; mkdir -p /var/cache/apt/archives

# download-only msodbcsql17 to directory
RUN install_packages -y -d -o=dir::cache=$STAGEPATH/deb -o Debug::NoLocking=1 msodbcsql17

# download & build pip wheels to directory
RUN mkdir -p $STAGEPATH/pip-wheels
RUN pip install wheel
RUN python -m pip wheel --wheel-dir=$STAGEPATH/pip-wheels \
    pyodbc \
    apache-airflow-providers-odbc \
    apache-airflow-providers-microsoft-azure>=1.2.0

# next stage
FROM bitnami/$IMAGE:$TAG as airflow

# refresh the arg within this stage
ARG STAGEPATH

# user root is required for installing packages
USER root

# install required packages for pyodbc
RUN install_packages unixodbc-dev

# copy pre-built pip packages from first stage
RUN mkdir -p $STAGEPATH
COPY --from=builder $STAGEPATH $STAGEPATH

# install msodbcsql17 from
RUN export ACCEPT_EULA=Y;install_packages $STAGEPATH/deb/archives/msodbcsql17*.deb

# uninstall outdated and deprecated pip packages
RUN . /opt/bitnami/airflow/venv/bin/activate && python -m pip uninstall -y \
    apache-airflow-providers-microsoft-mssql \
    apache-airflow-providers-microsoft-azure

# install updated and required pip packages
RUN . /opt/bitnami/airflow/venv/bin/activate && python -m pip install --upgrade --no-index --find-links=$STAGEPATH/pip-wheels \
    pyodbc \
    apache-airflow-providers-odbc \
    apache-airflow-providers-microsoft-azure

# return to previous non-root user
USER 1001
