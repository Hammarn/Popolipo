FROM nfcore/base
MAINTAINER Hammarn <rickard.hammaren@ebc.uu.se>
LABEL authors="rickard.hammaren@ebc.uu.se" \
    description="Docker image containing all requirements for Popolipo pipeline"

COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/popolipo-0.1.0/bin:$PATH
