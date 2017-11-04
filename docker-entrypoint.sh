#! /bin/bash
python manage.py createsuperuser
python manage.py makemigrations
python manage.py migrate

touch /srv/logs/gunicorn.log
touch /srv/logs/access.log
tail -n 0 -f /srv/logs/*.log &

echo Starting Gunicorn
exec gunicorn medrec1.wsgi \ #:application \
        --name medrec1 \
        --bind 0.0.0.0:8000 \
        --workers 3 \
        --log-level=info \
        --log-file=/srv/logs/gunicorn.log \
        --access-logfile=/srv/logs/access.log \
        "$@"