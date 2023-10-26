FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y gcc git g++ wget ca-certificates curl gnupg && \
	mkdir -p /etc/apt/keyrings  && \
	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
	NODE_MAJOR=20 && \
	echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
	apt-get update && \
	apt-get install nodejs -y
	
RUN wget https://golang.org/dl/go1.21.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz && \
    rm go1.21.3.linux-amd64.tar.gz

ENV PATH $PATH:/usr/local/go/bin

RUN CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest 

ENV PATH=$PATH:/root/go/bin

RUN git clone https://github.com/zeon-studio/hugoplate.git && cd hugoplate && \
	npm run project-setup && \
	npm install

COPY ./conf/hugo.toml /hugoplate/exampleSite/hugo.toml
#COPY conf/avatar.jpg /var/hugo/static/themes/hugo-coder/images/avatar.jpg

EXPOSE 1313

WORKDIR /hugoplate

CMD     ["hugo", "server", \
         "--bind=0.0.0.0", \
         "--baseURL=https://kdhrif.42.fr/static", \
         "-p", "1313", \
        "--appendPort=false"]
