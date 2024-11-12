# HttpAdapterEx

Examples of business host and interoperability message classes.

## Install, build and start

Select a parent folder for HttpAdapterEx (e.g. C:\\- ). Go to that folder and:
```bash
git clone https://github.com/anssika/HttpAdapterEx.git
cd ./HttpAdapterEx
```

The new folder created, `./HttpAdapterEx`, will be called project **root folder**.

Go to the project root folder and build and start the containers:
```bash
docker compose build
docker compose up -d
```

## To access

- Production Configuration page: http://localhost:58160/csp/http/EnsPortal.ProductionConfig.zen
- Management Portal home: http://localhost:58160/csp/sys/UtilHome.csp

As login credentials, use any built in **username**, e.g. `SuperUser` (not case sensitive) and **password:** `sys` (case sensitive).

## To test

Get ready to test:
1. Open Production Configuration page
2. check that you are working in namespace `HTTP`
3. open production `HttpAdapterEx.Production`
4. start the production




