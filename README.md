
A sample database with an integrated test suite, used to test your applications and database servers

This repository was migrated from [Launchpad](https://launchpad.net/test-db).

See usage in the [MySQL docs](https://dev.mysql.com/doc/employee/en/index.html)


## Where it comes from

The original data was created by Fusheng Wang and Carlo Zaniolo at 
Siemens Corporate Research. The data is in XML format.
http://timecenter.cs.aau.dk/software.htm

Giuseppe Maxia made the relational schema and Patrick Crews exported
the data in relational format.

The database contains about 300,000 employee records with 2.8 million 
salary entries. The export data is 167 MB, which is not huge, but
heavy enough to be non-trivial for testing.

The data was generated, and as such there are inconsistencies and subtle
problems. Rather than removing them, we decided to leave the contents
untouched, and use these issues as data cleaning exercises.


## Installation:

1. Download the repository
2. Change directory to the repository

Then run

    mysql < employees.sql


If you want to install with two large partitioned tables, run

    mysql < employees_partitioned.sql


## Testing the installation

After installing, you can run one of the following

    mysql -t < test_employees_md5.sql
    # OR
    mysql -t < test_employees_sha.sql

For example:

    mysql  -t < test_employees_md5.sql
    +----------------------+
    | INFO                 |
    +----------------------+
    | TESTING INSTALLATION |
    +----------------------+
    +--------------+------------------+----------------------------------+
    | table_name   | expected_records | expected_crc                     |
    +--------------+------------------+----------------------------------+
    | employees    |           300024 | 4ec56ab5ba37218d187cf6ab09ce1aa1 |
    | departments  |                9 | d1af5e170d2d1591d776d5638d71fc5f |
    | dept_manager |               24 | 8720e2f0853ac9096b689c14664f847e |
    | dept_emp     |           331603 | ccf6fe516f990bdaa49713fc478701b7 |
    | titles       |           443308 | bfa016c472df68e70a03facafa1bc0a8 |
    | salaries     |          2844047 | fd220654e95aea1b169624ffe3fca934 |
    +--------------+------------------+----------------------------------+
    +--------------+------------------+----------------------------------+
    | table_name   | found_records    | found_crc                        |
    +--------------+------------------+----------------------------------+
    | employees    |           300024 | 4ec56ab5ba37218d187cf6ab09ce1aa1 |
    | departments  |                9 | d1af5e170d2d1591d776d5638d71fc5f |
    | dept_manager |               24 | 8720e2f0853ac9096b689c14664f847e |
    | dept_emp     |           331603 | ccf6fe516f990bdaa49713fc478701b7 |
    | titles       |           443308 | bfa016c472df68e70a03facafa1bc0a8 |
    | salaries     |          2844047 | fd220654e95aea1b169624ffe3fca934 |
    +--------------+------------------+----------------------------------+
    +--------------+---------------+-----------+
    | table_name   | records_match | crc_match |
    +--------------+---------------+-----------+
    | employees    | OK            | ok        |
    | departments  | OK            | ok        |
    | dept_manager | OK            | ok        |
    | dept_emp     | OK            | ok        |
    | titles       | OK            | ok        |
    | salaries     | OK            | ok        |
    +--------------+---------------+-----------+

## Using mysql docker container

This container relies on the repository:    
https://github.com/AJNOURI/test_db   
forked from:  
https://github.com/datacharmer/test_db  

A sample database with Which is an integrated test suite, used to test your applications and database servers

## Building mysql docker container

    $ docker-compose up -d
    Creating network "testdb_default" with the default driver
    Creating testdb_myfakesql_1 ... done


    $ docker-compose ps
           Name                    Command             State           Ports         
    ---------------------------------------------------------------------------------
    testdb_myfakesql_1   docker-entrypoint.sh mysqld   Up      0.0.0.0:3306->3306/tcp

Create "employees" database:

    $ mysql -h 127.0.0.1 -u root -p -Bse "create database employees;

Load employees data:

    $ mysql -h 127.0.0.1 -u root -p "employees" < "employees.sql"
    Enter password: 
    INFO
    CREATING DATABASE STRUCTURE
    INFO
    storage engine: InnoDB
    INFO
    LOADING departments
    INFO
    LOADING employees
    INFO
    LOADING dept_emp
    INFO
    LOADING dept_manager
    INFO
    LOADING titles
    INFO
    LOADING salaries
    data_load_time_diff
    00:01:38

Commit the changes to an image:

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
    7ace9f9d5547        mysql:5.7           "docker-entrypoint..."   26 minutes ago      Up 26 minutes       0.0.0.0:3306->3306/tcp   testdb_myfakesql_1
    ajn@~/github/fake-mysql-db/test_db$ docker commit 7ace9f9d5547 ajnouri/fakemysqldb

And push to docker hub:

    $ docker push ajnouri/fakemysqldb
    The push refers to a repository [docker.io/ajnouri/fakemysqldb]
    cf80a4b6afc5: Pushed 
    c5479ef6e03d: Mounted from library/mysql 
    1df83efbc52b: Mounted from library/mysql 
    4b402dfbab7b: Mounted from library/mysql 
    14d83b80d542: Mounted from library/mysql 
    b0c77fd3841d: Mounted from library/mysql 
    317e578f94b9: Mounted from library/mysql 
    fbb39c7dedaf: Mounted from library/mysql 
    55d5d837463a: Mounted from library/mysql 
    f0f28cc0eea1: Mounted from library/mysql 
    813996252a80: Mounted from library/mysql 
    3358360aedad: Mounted from library/haproxy 
    latest: digest: sha256:76a8331db4530bea31ab5e144b40d748ad3056b29ab4c642ecaeed669e5a4540 size: 2828





