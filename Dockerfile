FROM fredhutch/r-shiny-server-base:4.3.2

RUN R -e "install.packages(c('bslib', 'shiny', 'bsicons', 'htmltools', 'ggplot2', 'fontawesome', 'DT', 'remotes'), repos='https://cran.rstudio.com/')"

RUN R -e 'remotes::install_github("fhdsl/metricminer")'

ADD . /app/

WORKDIR /app

RUN R -f check.R --args bslib shiny bsicons htmltools ggplot2 fontawesome DT remotes

EXPOSE 3838

CMD R -f app.R
