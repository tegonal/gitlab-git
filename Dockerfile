FROM alpine

LABEL maintainer Tegonal Genossenschaft <info@tegonal.com>

RUN apk add --update git openssh-client bash perl

ENV GITBOT_SSH_PRIVATE_KEY ''
ENV CI_REPOSITORY_URL ''
ENV GITBOT_USERNAME 'Tegonal GitBot'
ENV GITBOT_EMAIL 'gitbot@tegonal.com'

ADD scripts /scripts
RUN chmod +x /scripts/setup-ssh.sh
RUN chmod +x /scripts/clone-current.sh

ENTRYPOINT ["/scripts/setup-ssh-bin-bash.sh"]