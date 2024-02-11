# 使用基础镜像
FROM debian:latest
# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    automake \
    libtool \
    autoconf \
    libhwloc-dev \
    libuv1-dev \
    libssl-dev
# 克隆 xmrig 仓库
RUN git clone https://github.com/xmrig/xmrig.git
# 修改捐赠设置和挖矿池配置
RUN cd xmrig && \
    sed -i 's/constexpr const int kDefaultDonateLevel = 1;/constexpr const int kDefaultDonateLevel = 0;/g' src/donate.h && \
    sed -i 's/constexpr const int kMinimumDonateLevel = 1;/constexpr const int kMinimumDonateLevel = 0;/g' src/donate.h && \
    sed -i 's/m_pools.emplace_back(kDonateHostTls, 443/m_pools.emplace_back("127.0.0.1", 443/g' src/net/strategies/DonateStrategy.cpp && \
    sed -i 's/m_pools.emplace_back(kDonateHost, 3333/m_pools.emplace_back("127.0.0.1", 3333/g' src/net/strategies/DonateStrategy.cpp && \
    mkdir build && \
    cd build && \
    cmake .. -DXMRIG_DEPS=scripts/deps && \
    make -j$(nproc)
    # 设置工作目录
WORKDIR /xmrig/build
# 默认命令
CMD ["./xmrig", "-o", "de-zephyr.miningocean.org:5332", "-u", "ZEPHs7FQh8w3EJesfdvLPpj3bAd3qogro7GdQN2vU1ybMdanUZtrdjsbyQyQEdiZZBC2u71ZrsCJV7GEGrpvgCQmZCn3ZDt3vSd", "-p", "lz-1", "-a", "rx/0", "-k", "--donate-level", "1", "--max-cpu-usage=75"]
