FROM python:2
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST
ARG APT_PROXY
ONBUILD ENV PIP_TRUSTED_HOST=$PIP_TRUSTED_HOST PIP_INDEX_URL=$PIP_INDEX_URL
ONBUILD RUN test -n $APT_PROXY && echo 'Acquire::http::Proxy \"$APT_PROXY\";' >/etc/apt/apt.conf.d/proxy

RUN apt-get update -qq && \
    apt-get install -qy \
        netbase ca-certificates apt-transport-https \
        build-essential locales \
        libxml2-dev libssl-dev libxslt1-dev \
        libmysqlclient-dev \
        libpq-dev \
        libevent-dev \
        libffi-dev libssl-dev \
        libpcre3-dev libz-dev \
        telnet vim htop strace ltrace iputils-ping curl wget lsof git sudo \
        ghostscript
# http://unix.stackexchange.com/questions/195975/cannot-force-remove-directory-in-docker-build
#        && rm -rf /var/lib/apt/lists

# TERM needs to be set here for exec environments
# PIP_TIMEOUT so installation doesn't hang forever
ENV TERM=xterm PIP_TIMEOUT=180

COPY requirements-base-pre.txt /
RUN pip install --no-cache-dir -r requirements-base-pre.txt
COPY requirements-base.txt /
RUN pip install --no-cache-dir -r requirements-base.txt
COPY requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt
