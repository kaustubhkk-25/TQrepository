﻿# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# This Dockerfile sets up a PostgreSQL 9.6 server
# Adapted from: https://github.com/StefanScherer/dockerfiles-windows/blob/master/postgres/Dockerfile
#FROM microsoft/windowsservercore@sha256:c06b4bfaf634215ea194e6005450740f3a230b27c510cf8facab1e9c678f3a99

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN [Net.ServicePointManager]::SecurityProtocol = 'Tls12, Tls11, Tls' 
RUN Invoke-WebRequest -UseBasicParsing -Uri 'https://get.enterprisedb.com/postgresql/postgresql-13.3-2-windows-x64.exe' -OutFile 'postgresql-installer.exe'
RUN Start-Process postgresql-installer.exe -ArgumentList '--mode unattended --superpassword password' -Wait
RUN Remove-Item postgresql-installer.exe -Force

RUN Invoke-WebRequest -UseBasicParsing -Uri 'https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.3/ServiceMonitor.exe' -OutFile 'ServiceMonitor.exe'

RUN get-process

SHELL ["cmd", "/S", "/C"]

RUN setx /M PATH "C:\\Program Files\\PostgreSQL\\13\\bin;%PATH%"
RUN setx /M DATA_DIR "C:\\Program Files\\PostgreSQL\\13\\data"
RUN setx /M PGPASSWORD "password"
    
#RUN powershell -Command "Do { pg_isready -q } Until ($?)"
RUN echo listen_addresses = '*' >> "%DATA_DIR%\\postgresql.conf"
RUN    echo host  all  all  0.0.0.0/0  trust >> "%DATA_DIR%\\pg_hba.conf"
RUN    echo host  all  all  ::0/0      trust >> "%DATA_DIR%\\pg_hba.conf"
#RUN    net stop postgresql-x64-13

EXPOSE 5432

CMD ["ServiceMonitor.exe", "postgresql-x64-13"]
