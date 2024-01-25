FROM ubuntu:22.04
ENV GO_VERSION=go1.21.5
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install --yes --no-install-recommends --quiet \
    fish \
    apache2-utils \
    binutils \
    bird \
    bison \
    bpfcc-tools \
    bridge-utils \
    build-essential \
    conntrack \
    ctop \
    curl \
    dhcping \
    dnsutils \
    ethtool \
    fping \
    fzf \
    gdb \
    git \
    gnupg2 \
    htop \
    httpie \
    iftop \
    iperf \
    iproute2 \
    ipset \
    iptables \
    iptraf-ng \
    iputils-ping \
    ipvsadm \
    jq \
    liboping-dev \
    libunwind8 \
    linux-tools-common \
    mtr \
    mycli \
    netcat \
    netgen \
    nftables \
    ngrep \
    nmap \
    pgcli \
    postgresql \
    python3-pip \
    python3.10 \
    scapy \
    snmp \
    snmpd \
    socat \
    software-properties-common \
    strace \
    tcpdump \
    tcptraceroute \
    termshark \
    tmux \
    tshark \
    unzip \
    util-linux \
    vim \
    wuzz \
    ranger \
    pipx

WORKDIR /usr/local/bin

# Get pip packages 
RUN pipx install litecli && pipx install iredis 
# Get flamegraph 
RUN curl -L https://github.com/brendangregg/FlameGraph/archive/refs/heads/master.zip -o flamegraph.zip && \
    unzip flamegraph.zip && \
    rm flamegraph.zip && \
    echo "alias flamegraph='/usr/local/bin/FlameGraph-master/flamegraph.pl'" >> /root/.bashrc && \
    #Get gvm and install golang
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer) && \
    source /root/.gvm/scripts/gvm && \
    gvm install $GO_VERSION -B && \
    gvm use $GO_VERSION --default

ENV GOROOT="/root/.gvm/gos/$GO_VERSION/"
ENV PATH="$PATH:/root/.gvm/gos/$GO_VERSION/bin:root/go/bin"

# Get go based utilities
RUN go install github.com/go-delve/delve/cmd/dlv@latest && go install github.com/ofabry/go-callvis@latest && go install github.com/google/pprof@latest 

CMD ["/bin/fish"]
