FROM alpine:latest

RUN apk --no-cache add bash python3

COPY checkprefix.sh /usr/local/bin/checkprefix.sh
COPY serve_metrics.py /usr/local/bin/serve_metrics.py

RUN chmod +x /usr/local/bin/checkprefix.sh
RUN chmod +x /usr/local/bin/serve_metrics.py

# Create a cron job that runs the checkprefix.sh script every minute
RUN echo "* * * * * /usr/local/bin/checkprefix.sh >> /var/log/checkprefix.log 2>&1" > /etc/crontabs/root

# Start both checkprefix.sh and serve_metrics.py in the foreground
CMD ["sh", "-c", "crond -l 2 -f & /usr/local/bin/serve_metrics.py"]
