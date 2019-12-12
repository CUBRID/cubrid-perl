
DBD::cubrid - an CUBRID interface for Perl 5.
=============================================
```
   Copyright (c) 2011  Zhang Hui, China
```

The driver installation is described in

``
  INSTALL.html
```

Install
-------

1. Windows/ActivePerl

```
ppm install DBI
ppm install DBD::cubrid
```

2. Linux

```
perl -MCPAN -e shell
install DBD::cubrid
```

Build from source
-----------------
* GNU Developer Toolset 6 or higher is required (Linux)
```
$ git clone git@github.com:CUBRID/cubrid-perl.git
$ cd cubrid-perl
$ perl Makefile.PL
$ make
... run CUBRID Database Service ...
$ make test
$ make install
```
