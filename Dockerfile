# Version: 0.0.1
FROM nginx:1.19
MAINTAINER Julio Saldivar "cabildo@gmail.com"

ENV CERT_PASS web2py
ENV CERT_DOMAIN web2py.local
#password web2py admin
ENV PW admin

EXPOSE 443 80 8000

RUN apt-get update && \
    apt-get install wget -y && \
    apt-get install unzip -y && \
    apt-get -y install python3  python3-pip && \
    pip3 install gunicorn

RUN apt-get install -y supervisor

RUN wget https://mdipierro.pythonanywhere.com/examples/static/web2py_src.zip && \
	unzip web2py_src.zip && \
	rm web2py_src.zip

WORKDIR /web2py

RUN python3 -c "from gluon.main import save_password; save_password('$PW',80)" && \
	python3 -c "from gluon.main import save_password; save_password('$PW',443)" && \
    python3 -c "from gluon.main import save_password; save_password('$PW',8000)"

# copy nginx config
ADD web2py /etc/nginx/conf.d/default.conf

RUN mkdir /certs

WORKDIR /certs

RUN openssl genrsa -passout pass:$CERT_PASS 2048 > web2py.key && \
    openssl req -new -x509 -nodes -sha1 -days 1780 -subj "/C=US/ST=Denial/L=Chicago/O=Dis/CN=$CERT_DOMAIN" -key web2py.key > web2py.crt && \
    openssl x509 -noout -fingerprint -text < web2py.crt > web2py.info


WORKDIR /

COPY nginx.conf /etc/supervisor/conf.d/nginx.conf
COPY web2py.conf /etc/supervisor/conf.d/web2py.conf
CMD ["supervisord", "-n"]