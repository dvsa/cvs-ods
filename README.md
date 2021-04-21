# cvs-nop

Create NO-OP database locally

### Prerequisites :

- installed Liquibase
- installed MySQL Database Software
- installed MySQL Connector/J (https://dev.mysql.com/doc/connectors/en/connector-j-binary-installation.html)

### 1. Liquibase Steps

A. Create configuration file
   `liquibase.properties`, provide database name (default: CVSBNOP), database username and password and class path to
   MySQL J/Connector.

```properties
driver: com.mysql.cj.jdbc.Driver
url: jdbc:mysql://localhost:3306/CVSBNOP?createDatabaseIfNotExist=true
username: root
password: password
classpath: mysql-connector-java-8.0.23.jar
```

B. Once database is up and running (database user needs to have privileges in order to create database objects)

Run: ``liquibase --defaultsFile liquibase.properties --changeLogFile changelog-master.xml update``

Running without configuration file (provide missing paths / user credentials):

`liquibase --url=jdbc:mysql://localhost:3306/CVSB19155?createDatabaseIfNotExist=true --driver=com.mysql.cj.jdbc.Driver --classpath=mysql-connector-java-8.0.23.jar --username=root --password=password --changeLogFile changelog-master.xml update`

Quick step to instantiate database in Docker:

`docker run --name local-mysql -e MYSQL_ROOT_PASSWORD=password -p3306:3306 -d mysql:5.7`

### 2. Schema Inventory

Tables

2.1. Common for Technical Record And Test Result

* `vehicle_class (fg)`
* `vehicle_subclass (fg)`
* `identity (fg)`

Technical Record

*  `contact_details (fg)`
*  `make_model (fg)`
*  `tyre (fg)`

Test Result

*  `fuel_emission (fg)`
*  `location (fg)`
*  `preparer (fg)`
*  `tester (fg)`
*  `test_station (fg)`
*  `test_type (fg)`

2.2. Subsets

*  `vehicle`

Technical Record

*  `axles`
*  `axle_spacing`
*  `microfilm (fg)`
*  `plate (fg)`
*  `psv_brakes`
*  `technical_record`

Test Result

*  `custom_defect`
*  `defect (fg)`
*  `test_defect`
*  `test_result`

*(fg) - tables with `fingerprint` virtual column

3.3. Fingerprints 

Tables marked (fg) contain a function-based stored virtual column, the function derives a hash key for
all records (based on concatenated value of all columns without `id` ) that are inserted or updated. The column's value is stored and indexed with unique constraint.
This allow to lever native database support for upsert syntax `INSERT INTO ... ON DUPLICATE KEY UPDATE`.

4. ADR data set 

This set is not a part of MVP, tables serve as a reference for a future development.  

Tables :
* `adr`
* `additional_notes_number`
* `additional_notes_guidance`
* `dangerous_goods`
* `permitted_dangerous_goods`
* `productListUnNo`
* `adr_productListUnNo`